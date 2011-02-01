require 'rubygems'
require 'bundler/setup'
require 'rspec'

root = File.expand_path('../..', __FILE__)
Dir["#{root}/spec/support/**/*.rb"].each {|f| require f}

Bundler.require
