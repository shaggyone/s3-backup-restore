require "rubygems"
# require "bundler/setup"

require 'aws/s3'
require 'pp'
require 'fileutils'
require 'optparse'
require 'yaml'

class S3Downloader
  def initialize(options)
    @s3_security = {:access_key_id => options[:access_key_id], :secret_access_key => options[:secret_access_key]}
    @bucket = options[:bucket]
    @prefix = options[:prefix]
    @to     = options[:to]
  end

  def run
    AWS::S3::Base.establish_connection!(@s3_security)
    files = AWS::S3::Bucket.find(@bucket)
    re = /^(.*?)\.\d{8}\..*$/
    resources = files.map do |f| a = f.path.match(re); a[1] unless a.nil? end.uniq.find_all do |f| not f.nil? and f.to_s.start_with?("/#{@bucket}/#{@prefix}") end
    pp resources
    res_files = {}
    resources.each do |res|
      rf = files.find_all do |f| f.path.start_with?(res) end.sort do |a,b| a.path <=> b.path end
      master_files = rf.find_all do |f| f.path.include?(".master.") end
      master_file = if master_files
                      master_files.last 
                    else
                      nil
                    end
      rf = if master_file.nil?
             [rf.last]
           else
             rf.find_all do |f| f.path >= master_file.path end
           end
      res_files[res] = rf
    end

    pp res_files

    FileUtils.makedirs(@to)
    Dir.chdir(@to) do
      res_files.each do |key, value|
        value.each do |f|
          pp f
          File.open(f.key, 'w') do |file|
            AWS::S3::S3Object.stream(f.key, f.bucket.name) do |chunk|
              file.write chunk
            end
          end
        end
      end
    end
  end
end

options = {}
options[:config] = '/etc/s3-restore.yml'

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
  opts.on('-v', '--verbose', 'Output verbose information') do
    options[:verbose] = true
  end

  opts.on('-c', '--config=config_file', 'Alternate config file') do |file|
    options[:config] = file
  end

  opts.on('-a', '--s3-access-key=key', 'S3 access key') do |key|
    options[:access_key_id] = key
  end

  opts.on('-s', '--s3-secret-access-key=key', 'S3 secret access key') do |key|
    options[:secret_access_key] = key
  end

  opts.on('-b', '--bucket=bucket', 'S3 bucket name') do |bucket|
    options[:bucket] = bucket
  end

  opts.on('-p', '--prefix=prefix', 'Backup prefix') do |prefix|
    options[:prefix] = prefix
  end

  opts.on('-t', '--to=dest', 'Destination folder (will be created, if not exist)') do |dest|
    options[:to] = dest
  end

  opts.on('-h', '--help', 'Display help screen') do
    puts opts
    exit
  end
end

mandatory_options = [:bucket, :to]


opt_parser.parse!

if File.readable?(options[:config]) then
  file_options = {}
  YAML::load(File.read(options[:config])).each do |key, value|
    file_options[key.to_sym] = value
  end
  
  options = file_options.merge(options)
end

if mandatory_options.find {|opt| !options.has_key?(opt)} then
# pp file_options
  puts opt_parser
  exit
end
#pp options
#exit

s3_downloader = S3Downloader.new options
s3_downloader.run
