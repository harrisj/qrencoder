require 'rake/extensiontask'
require "rspec/core/rake_task"

Rake::ExtensionTask.new('qrencoder_ext') do |ext|
  ext.lib_dir = 'lib/qrencoder'
end

RSpec::Core::RakeTask.new

task :default => [:clean, :compile, :spec]

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "qrencoder #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
