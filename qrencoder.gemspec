lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'qrencoder/version'

Gem::Specification.new do |s|
  s.version = QRCode::VERSION
  s.platform = Gem::Platform::RUBY

  s.name = "qrencoder"
  s.summary = %Q{Wrapper around the C qrencode library for creating QR Codes}
  s.description = %Q{This Gem is a wrapper around an useful open-source library for creating QR
  Codes, a two-dimensional bar code format popular in Japan created by the Denso-Wave Corporation in 1994.}
  s.email = 'harrisj@schizopolis.net'
  s.homepage = 'http://nycrb.rubyforge.org/qrencoder'
  s.authors = ['Jacob Harris', "Wesley Moore"]
  s.date     = '2010-11-23'

  s.extra_rdoc_files = ["README.rdoc"]
  s.files = Dir.glob("{bin,lib,ext}/**/*") + %w(History.txt README.rdoc)

  s.require_path = 'lib'
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec", "~> 2.4.0"
  s.add_development_dependency "rake-compiler", "~> 0.7.5"
  s.add_runtime_dependency "png", "~> 1.2.0"
  s.add_runtime_dependency "RubyInline", '>=3.6.2'

  s.test_files = Dir.glob("spec/**/*_spec.rb") + %w{spec/spec_helper.rb}
end
