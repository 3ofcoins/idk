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

      puts <<EOF
Infrastructure Development Kit #{version}
===============================#{'=' * version.length}

Downloads
---------

EOF

      connection = Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        path_style: true)
      bucket = connection.directories.get('downloads.3ofcoins.net')
      bucket.files.all(prefix: "idk/#{version}").each do |file|
        next if file.key =~ /\.json$/
        pretty_size = Filesize.from("#{file.content_length} B").pretty
        public_url = file.service.request_url(bucket_name: bucket.key, object_name: file.key)

        remarks = case File.basename(file.key)
                  when /mac_os_x\.10\.7\.\d+\.sh$/
                    'also for OSX 10.6'
                  end

        line = " - [#{File.basename(file.key)}](#{public_url}) &mdash; #{pretty_size}"
        line << " (#{remarks})" if remarks
        puts line
      end

      puts <<EOF

Changes
-------

EOF
      found = nil
      prev = nil
      File.open('CHANGELOG.md').lines.each do |line|
        line.strip!
        if !found
          found = true if line == version
          next
        end

        if line =~ /^-+$/
          if prev then break else next end
        end

        puts prev if prev && !prev.empty?
        prev = line
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

begin
  require 'kitchen/thor_tasks'
  Kitchen::ThorTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
