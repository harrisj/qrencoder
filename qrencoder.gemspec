lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.version = '0.1.0'
  s.platform = Gem::Platform::RUBY

  s.name = "qrencoder"
  s.summary = %Q{Wrapper around the C qrencode library for creating QR Codes}
  s.description = %Q{This Gem is a wrapper around an useful open-source library for creating QR
  Codes, a two-dimensional bar code format popular in Japan created by the Denso-Wave Corporation in 1994.}
  s.email = 'harrisj@schizopolis.net'
  s.homepage = 'http://nycrb.rubyforge.org/qrencoder'
  s.authors = ['Jacob Harris', "Wesley Moore"]
  s.date     = '2010-11-23'

  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.rdoc CHANGELOG.rdoc init.rb)

  s.require_path = 'lib'
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec", "= 1.3.0"
  s.add_development_dependency "rake-compiler", ">= 0.7.0"
  s.add_runtime_dependency 'png', '>=1.0.0'

  s.test_files = Dir.glob("spec/**/*_spec.rb") + %w{spec/spec_helper.rb}
end

