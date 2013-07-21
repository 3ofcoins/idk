require 'rubygems'
require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require 'wrong'

Wrong.config.alias_assert :expect, override: true

module IDK
  module Spec
    module WrongHelper
      include Wrong::Assert
      include Wrong::Helpers

      def increment_assertion_count
        self.assertions += 1
      end
    end
  end
end

class MiniTest::Spec
  include IDK::Spec::WrongHelper
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.command_name 'rake spec'
end

require "idk/cli"
