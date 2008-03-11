# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/qrencoder.rb'

Hoe.new('qrencoder', QRCode::GEM_VERSION) do |p|
  p.rubyforge_name = 'nycrb'
  p.author = 'Jacob Harris'
  p.email = 'harrisj@schizopolis.net'
  p.summary = 'A gem for creating 2-dimensional barcodes following the QR Code specification.'
  # p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = 'http://nycrb.rubyforge.org/qrencoder'
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.extra_deps << ['RubyInline', '>=3.6.2']
  p.extra_deps << ['png', '>=1.0.0']
end

# vim: syntax=Ruby
