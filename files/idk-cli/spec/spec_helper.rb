require 'rubygems'
require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require 'wrong'
require 'wrong/adapters/minitest'

Wrong.config.alias_assert :expect, override: true
include Wrong

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.command_name 'rake spec'
end

require "idk-cli"
