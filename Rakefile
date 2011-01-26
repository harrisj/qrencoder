require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  jewel = Jeweler::Tasks.new do |gem|
    gem.name = "qrencoder"
    gem.summary = %Q{Wrapper around the C qrencode library for creating QR Codes}
    gem.description = %Q{This Gem is a wrapper around an useful open-source library for creating QR
    Codes, a two-dimensional bar code format popular in Japan created by the Denso-Wave Corporation in 1994.}
    gem.email = 'harrisj@schizopolis.net'
    gem.homepage = 'http://nycrb.rubyforge.org/qrencoder'
    gem.authors = ['Jacob Harris', "Wesley Moore"]
    gem.add_development_dependency "rspec", "= 1.3.0"
    gem.add_development_dependency "rake-compiler", ">= 0.7.0"
    gem.add_runtime_dependency "RubyInline", '>=3.6.2'
    gem.add_runtime_dependency 'png', '>=1.0.0'

    # gem.rubyforge_name = 'nycrb'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/extensiontask'
Rake::ExtensionTask.new('qrencoder_ext') do |ext|
  ext.lib_dir = 'lib/qrencoder'
end

gem 'rspec', '=1.3.0'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => [:clean, :compile, :spec]

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "qrencoder #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
