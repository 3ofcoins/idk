# -*- ruby -*-

require 'rubygems'

require 'bundler/setup'

require 'rake/testtask'
require 'thor/rake_compat'

module IDK
  class Tasks < Thor
    namespace 'idk'
    include Thor::Actions

    desc 'describe_release [VERSION]',
         'Generate a Markdown list of download links for a release'
    def describe_release(version=nil)
      require 'filesize'
      require 'fog'
      require 'minigit'

      version ||= MiniGit::Capturing.describe.strip.sub(/-.*$/, '')

      puts "Infrastructure Development Kit #{version}\n#{'=' * (31+version.length)}\n"

      connection = Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
      bucket = connection.directories.get('downloads.3ofcoins.net')
      bucket.files.all(prefix: "idk/#{version}").each do |file|
        next if file.key =~ /\.json$/
        pretty_size = Filesize.from("#{file.content_length} B").pretty
        public_url = file.service.request_url(bucket_name: bucket.key, object_name: file.key)
        puts " - [#{File.basename(file.key)}](#{public_url}) (#{pretty_size})"
      end
    end

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
