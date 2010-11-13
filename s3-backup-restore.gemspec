# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{s3-backup-restore}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Zagorski aka shaggyone"]
  s.date = %q{2010-11-13}
  s.description = %q{Downloads backup files from amazon s3 uploaded by backup-manager.}
  s.email = %q{victor@zagorski.ru}
  s.files = ["Rakefile", "s3-restore.rb", "Manifest", "s3-backup-restore.gemspec"]
  s.homepage = %q{https://shaggyone@github.com/shaggyone/s3-backup-restore.git}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "S3-backup-restore"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{s3-backup-restore}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Downloads backup files from amazon s3 uploaded by backup-manager.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
