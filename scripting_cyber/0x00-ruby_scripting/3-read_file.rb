#!/usr/bin/env ruby
require 'json'

def count_user_ids(path)
  file = File.read(path)

  data = JSON.parse(file)

  counts = Hash.new(0)

  data.each do |item|
    user_id = item['userId']
    counts[user_id] += 1
  end

  counts.sort.each do |user_id, count|
    puts "#{user_id}: #{count}"
  end
end
