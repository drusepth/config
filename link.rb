#!/usr/bin/ruby

require 'fileutils'

def backup dotfile
  backup_dir = [Dir.pwd, 'backups'].join '/'
  Dir.mkdir backup_dir unless File.directory? backup_dir

  unless File.exist?([backup_dir, dotfile].join '/')
    puts "\tMoving existing dotfile #{[Dir.home, dotfile].join('/')} --> #{backup_dir}"
    FileUtils.move([Dir.home, dotfile].join('/'), backup_dir)
  end
end

def link dotfile
  src = [Dir.home, dotfile].join '/'
  dst = [Dir.pwd, dotfile].join '/'
  
  if File.exist? src
    puts "\tDeleting existing #{src}"
    File.delete src
  end

  puts "\tLinking #{src} --> #{dst}"
  `ln -s #{dst} #{src}`
end

(Dir.glob(".*") - %w{. .. .git .gitignore}).each do |dotfile|
  puts "#{dotfile}"

  filepath = [Dir.home, dotfile].join '/'
  backup dotfile if File.exist? filepath

  link dotfile
end
