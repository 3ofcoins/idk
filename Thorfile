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

class Omnibus < Thor
  include Thor::Actions
  desc 'build [SOFTWARE [...]]', 'Build Omnibus project or individual software'
  def build(*softwares)
    if softwares.empty?
      run 'omnibus build project idk'
    else
      softwares.each do |software|
        run "omnibus build software idk #{software}"
      end
    end
  end

  DOCKER_PLATFORMS=%w[raring64 precise64 lucid64 precise32 lucid32]
  desc 'docker_build [PLATFORM ...]', "Build with Docker on PLATFORMs (default: #{DOCKER_PLATFORMS.join(' ')})"
  def docker_build(*platforms)
    platforms = DOCKER_PLATFORMS if platforms.empty?
    failed = []
    platforms.each do |platform|
      run "time docker run -v=`pwd`:/src mpasternacki/#{platform}:omnibus-builder"
      unless $?.success?
        say_status :failed, "#{platform} build failed (#{$?})", :red
        failed << platform
      end
    end
    say_status 'FAILED', failed.join(', '), :red unless failed.empty?
  end
end
