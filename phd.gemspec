# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Noel Peden"]
  gem.email         = ["noel@peden.biz"]
  gem.description   = %q{Phd is a tool to browse changes in disk space usage. It creates an sqlite3 index and creates SVG images of the usage. The svg uses area and color to display both file size and size change relative to the compared date. Phd is a near complete rewrite of philesight (http://zevv.nl/play/code/philesight/) with many changes.}
  gem.summary       = %q{Use phd to view disk usage over time.}
  gem.homepage      = "http://phd.peden.biz"

  gem.files         = Dir["lib/**/*"] + Dir['[A-Z]*'] - ['Guardfile']
  gem.executables   = ['phd']
  gem.test_files    = Dir["spec/**/*"] + ['Guardfile']
  gem.name          = "phd"
  gem.require_paths = ["lib"]
  gem.version       = Phd::VERSION

  gem.add_dependency 'sinatra'
  gem.add_dependency 'sqlite3'
  gem.add_dependency 'progress_bar'
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "capybara"
  gem.add_development_dependency "growl"
  gem.add_development_dependency "rb-fsevent"
end
