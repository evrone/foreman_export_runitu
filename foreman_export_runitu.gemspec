$:.unshift File.expand_path("../lib", __FILE__)
require "foreman/version"

Gem::Specification.new do |gem|
  gem.name     = "foreman_export_runitu"
  gem.version  = "0.0.1"

  gem.author   = "Dmitry Galisnky"
  gem.email    = "dima.exe@gmail.com"
  gem.homepage = "http://github.com/dima-exe/foreman_export_runitu"
  gem.summary  = "Foreman exporter to runit, unlike original runit exporter, does it without sudo"

  gem.description = gem.summary

  gem.files = Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

  gem.add_dependency 'foreman'
end
