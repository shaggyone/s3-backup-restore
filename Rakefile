require 'rubygems'  
require 'rake'  
require 'echoe'  
  
Echoe.new('s3-backup-restore', '0.0.1') do |p|  
    p.description     = "Downloads backup files from amazon s3 uploaded by backup-manager."
    p.url             = "https://shaggyone@github.com/shaggyone/s3-backup-restore.git"
    p.author          = "Victor Zagorski aka shaggyone"  
    p.email           = "victor@zagorski.ru"
    p.ignore_pattern  = ["tmp/*", "script/*"]  
    p.development_dependencies = []  
end  
  
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
