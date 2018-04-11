#!/usr/bin/env ruby
require 'pathname'
require 'fileutils'
include FileUtils

# path to your application root.
APP_ROOT = Pathname.new File.expand_path('../../', __FILE__)

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

chdir APP_ROOT do
  # This script is a starting point to setup your application.
  # Add necessary setup steps to this file.

  puts '== Installing dependencies =='
  system! 'gem install bundler --conservative'
  system('bundle check') || system!('bundle install')

  # Install JavaScript dependencies if using Yarn

  puts "\n== Copying .env sample file =="
  unless File.exist?('.env')
    cp '.env.example', '.env'
  end

  puts "\n== Preparing database =="
  system! 'bin/rails db:setup'

  puts "\n== Installing git pre-commit hooks =="
  system! 'overcommit --install'
end
