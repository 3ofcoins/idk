# -*- ruby -*-

require 'rubygems'
require 'bundler/setup'

class Omnibus < Thor
  include Thor::Actions

  desc 'build [SOFTWARE [...]]', 'Build Omnibus project or individual software'
  method_option :purge, type: :boolean, desc: 'Do a clean build (meaningful only with a full build)'
  def build(*softwares)
    if softwares.empty?
      if options[:purge]
        remove_file '/opt/idk'
        empty_directory 'tmp'
        run 'omnibus clean --purge idk > tmp/clean.log'
      end
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
