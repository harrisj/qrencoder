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

desc "Benchmark C implementation against pure Ruby implementation (from rqrcode)"
task(:benchmark => [:clean, :compile]) do
  require 'rubygems'
  require 'benchmark'
  require 'bundler/setup'
  Bundler.require(:benchmark)

  require 'qrencoder'
  require 'rqrcode'

  Benchmark.bmbm do |benchmark|
    num = 100

    benchmark.report("rqrcode #{num}") do
      num.times do |i|
        RQRCode::QRCode.new("string #{i}").modules
      end
    end

    benchmark.report("qrencoder #{num}") do
      num.times do |i|
        QREncoder.encode("string #{i}", :correction => :high).data
      end
    end

    benchmark.report("qrencoder 100_000") do
      100_000.times do |i|
        QREncoder.encode("string #{i}", :correction => :high).data
      end
    end
  end
end

