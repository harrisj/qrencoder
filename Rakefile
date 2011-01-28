require 'rake/extensiontask'
require "rspec/core/rake_task"

Rake::ExtensionTask.new('qrencoder_ext') do |ext|
  ext.lib_dir = 'lib/qrencoder'
end

RSpec::Core::RakeTask.new

task :default => [:clean, :compile, :spec]

require 'rake/rdoctask'
require 'sdoc'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--fmt' << 'shtml' # explictly set shtml generator
  rdoc.template = 'direct' # lighter template used on railsapi.com

  rdoc.title = "qrencoder"
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('ext/**/*.c')
end
