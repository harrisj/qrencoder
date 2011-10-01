lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'qrencoder/version'

Gem::Specification.new do |s|
  s.version = QREncoder::VERSION
  s.platform = Gem::Platform::RUBY

  s.name = "qrencoder"
  s.summary = %Q{Wrapper around the C qrencode library for creating QR Codes}
  s.description = %Q{This Gem is a wrapper around an useful open-source library for creating QR
  Codes, a two-dimensional bar code format popular in Japan created by the Denso-Wave Corporation in 1994.}
  s.email = ['harrisj@schizopolis.net', 'josh@joshuadavey.com']
  s.homepage = 'http://nycrb.rubyforge.org/qrencoder'
  s.authors = ['Jacob Harris', 'Joshua Davey', 'Wesley Moore']
  s.date     = '2011-03-08'

  s.extensions = ["ext/qrencoder_ext/extconf.rb"]

  s.extra_rdoc_files = ["README.rdoc", "ext/qrencoder_ext/qrencoder_ext.c"]
  s.files = Dir.glob("{bin,lib,ext}/**/*") + %w(History.txt README.rdoc) - ["lib/qrencoder/qrencoder_ext.bundle"]

  s.require_path = 'lib'
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec", "~> 2.4"
  s.add_development_dependency "rake-compiler", "~> 0.7.5"
  s.add_development_dependency "sdoc", "~> 0.2.20"
  s.add_development_dependency "zxing", "~> 0.2.1"
  s.add_runtime_dependency "chunky_png", "~> 1.1"

  s.test_files = Dir.glob("spec/**/*_spec.rb") + %w{spec/spec_helper.rb}
end
