#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

def get_request(url)
  res = Net::HTTP.get_response(URI(url))
  puts "Response status: #{res.code} #{res.message}"
  puts "Response body:\n#{JSON.pretty_generate(JSON.parse(res.body))}"
end
