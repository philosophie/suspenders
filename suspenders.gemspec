# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'suspenders/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Suspenders::RUBY_VERSION}"
  s.authors = ['Philosophie']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Suspenders is a base Rails project that you can upgrade. It is used by
Philosophie to get a jump start on a working app. Use Suspenders if you're in a
rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  s.email = 'webmaster@philosophie.is'
  s.executables = ['philosophies-suspenders']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/philosophie/suspenders'
  s.license = 'MIT'
  s.name = 'philosophies-suspenders'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using Philosophie's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Suspenders::VERSION

  s.add_dependency 'bundler', '~> 2.0'
  s.add_dependency 'rails', Suspenders::RAILS_VERSION

  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rspec', '~> 3.6'
end
