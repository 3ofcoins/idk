require 'shellwords'

require 'thor'

require 'idk/version'
require 'idk/path'

require 'idk/cli/setup'

module IDK
  module CLI
    class Main < Thor
      include Actions

      check_unknown_options! except: [ :exec, :sudo ]
      stop_on_unknown_option! :exec, :sudo

      map '-h' => :help,
          '--help' => :help,
          '--version' => :version

      desc 'exec COMMAND ...', 'Run a shell command in IDK context'
      def exec(*command)
        exec! *command
      end

      desc 'sudo COMMAND ...', 'Run a shell command in IDK context as root'
      def sudo(*command)
        opts = (command.last.is_a?(Hash) ? command.pop : {})
        opts[:as_root] = true
        command << opts
        exec! *command
      end

      desc :version, 'Display version', :hidden => true
      def version
        puts "IDK #{VERSION}"
      end

      register Setup, 'setup', 'setup', 'Invoke a setup command'

      def self.start(given_args=ARGV, config={})
        if idk0 = ENV.delete('IDK0')
          $0 = idk0
        end

        config[:shell] ||= Thor::Base.shell.new
        setup_env(config[:shell])

        cmdname = File.basename($0)
        if cmdname != 'idk' && Path::EMBEDDED.join('bin', cmdname).exist?
          given_args = given_args.dup.unshift('exec', cmdname)
        end

        super(given_args, config)
      end

      private

      def self.setup_env(shell=nil)
        shell ||= Thor::Base.shell.net

        ENV['GEM_HOME'] = Path.gem_home
        ENV['GEM_PATH'] = Path.gem_path

        ENV['IDK_ORIG_PATH'] = ENV['PATH']
        ENV['PATH'] = [
          "#{Path::EMBEDDED}/bin",
          "#{Path.gem_home}/bin",
          Path::ROOT.join('bin').to_s,
          *ENV['PATH'].split(':').reject do |dir|
            dir =~ /^(?:#{Regexp.escape(Path::ROOT.to_s)}|#{Regexp.escape(Path::VAR.to_s)})/
          end
        ].join(':')

        # Sanity check (redundant on `idk setup`)
        return if (File.basename($0) == 'idk' && ARGV.first == 'setup') || ENV['idk_skip_warning']
        if !Path.setup_stamp.exist?
          shell.say_status 'WARNING',
                           'Unconfigured workstation',
                           :red
          shell.say_status 'ADVICE',
                           'Run "idk setup" to configure your environment',
                           :yellow
        elsif (!!ENV['idk_interactive']) && (!ENV['idk_profile_loaded'])
          shell.say_status 'WARNING',
                           'Unconfigured environment',
                           :red
          shell.say_status 'ADVICE',
                           'Try to log out and log in again, or re-run "idk setup"',
                           :yellow
          shell.say_status 'ADVICE',
                           'If this does not help, add following line to your .profile:',
                           :yellow
          shell.say_status nil,
                           "source /opt/idk/profile.sh",
                           :yellow
        end
      end
    end
  end
end
