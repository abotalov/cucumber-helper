# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cucumber-helper/version'

Gem::Specification.new do |gem|
  gem.name          = "cucumber-helper"
  gem.version       = Cucumber::Helper::VERSION
  gem.authors       = ["Alex Klimenkov"]
  gem.email         = ["alex.klimenkov89@gmail.com"]
  gem.description   = %q{Helper for cucumber}
  gem.summary       = %q{Helper fo cucumber: progress bar, check error after actions (click, visit)}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'ruby-progressbar', ['~> 1.0.0']
  gem.add_dependency 'capybara'
  gem.add_dependency 'cucumber'
end
