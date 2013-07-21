# -*- ruby -*-

require 'rubygems'

require 'bundler/setup'

require 'rake/testtask'
require 'thor/rake_compat'

module IDK
  class CLI < Thor
    namespace 'idk:cli'
    include Thor::RakeCompat
    include Thor::Actions

    Rake::TestTask.new :spec do |task|
      task.libs << 'spec'
      task.test_files = FileList['spec/**/*_spec.rb']
    end

    desc 'spec', 'Run specs'
    def spec
      inside 'files/idk-cli' do
        Rake::Task['spec'].execute
      end
    end
  end
end
