#!/usr/bin/env ruby

$:.unshift File.expand_path '../../../lib', __FILE__
require 'bundler'
Bundler.require :default, :development
require 'angelo'

class Casc < Angelo::Base

  post '/' do
    sses.each {|sse| sse.write sse_message(params[:msg])}
  end

  get '/' do
    eventsource do |es|
      es.on_close = ->{sses(false).remove_socket es}
      sses << es
    end
  end

  eventsource '/sse' do |es|
    es.on_close {sses(false).remove_socket es}
    sses << es
  end

end
Casc.run!
