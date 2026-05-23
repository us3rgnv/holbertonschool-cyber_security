#!/usr/bin/env ruby

require 'json'

def merge_json_files(file1_path, file2_path)

  array1 = File.exist?(file1_path) ? JSON.parse(File.read(file1_path)) : []
  array2 = File.exist?(file2_path) ? JSON.parse(File.read(file2_path)) : []

  merged_array = array2 + array1

  File.open(file2_path, 'w') do |f|
    f.write(JSON.pretty_generate(merged_array))
  end

  puts "Merged JSON written to #{file2_path}"
end
