#!/usr/bin/ruby
require 'fileutils'

save_existing_configs = true

ignored_files = ['.git']

backup_directory = 'old_config'

if save_existing_configs
  FileUtils.mkdir_p(File.dirname(backup_directory))
end

Dir.glob('.*') do |filename|
  next if filename == '.' or filename == '..'
  next if ignored_files.include? filename
  
  puts filename

  if save_existing_configs
    FileUtils.move("#{ENV['USER']}/#{filename}", "#{backup_directory}/#{filename}") if File.exists? "/home/#{ENV['USER']}/#{filename}"
  end
  
  File.delete("/home/#{ENV['USER']}/#{filename}") if File.exists? "/home/#{ENV['USER']}/#{filename}"
  #File.symlink("/home/#{ENV['USER']}/#{filename}", filename)
  File.symlink(filename, "/home/#{ENV['USER']}/#{filename}")
  puts "#{filename} linked"
end
