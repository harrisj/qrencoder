# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/qrencoder.rb'

Hoe.new('qrencoder', QRCode::GEM_VERSION) do |p|
  p.rubyforge_name = 'nycrb'
  p.developer('Jacob Harris', 'harrisj@schizopolis.net')

  # p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = 'http://nycrb.rubyforge.org/qrencoder'
  p.extra_deps << ['RubyInline', '>=3.6.2']
  p.extra_deps << ['png', '>=1.0.0']
end

# vim: syntax=Ruby
