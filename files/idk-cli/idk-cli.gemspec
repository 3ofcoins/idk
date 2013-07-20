# -*- mode: ruby; coding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idk/cli/version'       # FIXME: omnibus version

Gem::Specification.new do |spec|
  spec.name          = "idk-cli"
  spec.version       = IDK::CLI_VERSION
  spec.authors       = ["Maciej Pasternacki"]
  spec.email         = ["maciej@3ofcoins.net"]
  spec.description   = "Infrastructure Development Kit CLI"
  spec.summary       = "Infrastructure Development Kit CLI"
  spec.homepage      = "https://github.com/3ofcoins/idk/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.18.1'
  spec.add_dependency 'minigit', '~> 0.0.4'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency "wrong", ">= 0.7.0"
end
