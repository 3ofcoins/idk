require 'shellwords'

require 'thor'

require 'idk/version'
require 'idk/path'

require 'idk/cli/actions'

module IDK
  module CLI
    class Main < Thor
      include Actions

      check_unknown_options! except: [ :exec, :sudo ]
      stop_on_unknown_option! :exec, :sudo

      map '-h' => :help,
          '--help' => :help,
          '--version' => :version

      desc 'exec COMMAND ...', 'Execute a command in IDK context'
      method_option :root, :type => :boolean,
                    :desc => 'Execute the command as root, using `sudo` if necessary'
      def exec(*command)
        exec! *command, :as_root => options[:root]
      end

      desc :setup, 'Configure system'
      method_option :debug, :aliases => '-d', :type => :boolean,
                    :desc => "Show debug log"
      def setup
        ENV['idk_skip_warning'] = '1'
        inside '/opt/idk/solo' do
          chef_solo_command = 'chef-solo -c solo.rb -j dna.json'
          chef_solo_command << ' -l debug' if options[:debug]

          shell.say_status :run, "[/opt/idk/solo] #{chef_solo_command}"
          run "idk exec --root #{chef_solo_command}", verbose: false
          fatal! 'chef-solo failed' unless $?.success?
        end

        profile_sh = Path::ROOT.join('profile.sh')

        inside ENV['HOME'] do
          profiles = []

          # find bash's preferred init file
          bash_preferred = %w[.bash_profile .bash_login].
            find { |f| File.exist?(f) }
          profiles << bash_preferred if bash_preferred

          zsh_preferred = %w[.zprofile .zlogin].
            map { |f| ENV['ZDOTDIR'] ? File.join(ENV['ZDOTDIR'], f) : f }.
            find { |f| File.exist?(f) }
          if zsh_preferred
            profiles << zsh_preferred
          elsif ENV['SHELL'] =~ /\/zsh[^\/]*$/
            profiles << ( ENV['ZDOTDIR'] ? File.join(ENV['ZDOTDIR'], '.zprofile') : '.zprofile' )
          end

          profiles << '.profile'

          profiles.each do |profile|
            create_file profile unless File.exist?(profile)
            append_to_file profile, "\n# Infrastructure Development Kit\nif test -s #{profile_sh} ; then source #{profile_sh} ; fi\n"
          end
        end

        profile_sh = Path::ROOT.join('profile.sh')
        if ENV['idk_rvm_path']
          create_link File.join(ENV['idk_rvm_path'], 'hooks', 'after_use_idk'),
                      profile_sh
        end

        create_file Path.setup_stamp
        shell.say_status :done, "Now run `source /opt/idk/profile.sh' or log out and log in again", :green
      end

      desc :version, 'Display version', :hidden => true
      def version
        puts "IDK #{VERSION}"
      end

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

      def self.skip_warnings?
        ( File.basename($0) == 'idk' && ARGV.first == 'setup' ) ||
          ENV['idk_skip_warning']
      end

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
        return if skip_warnings?

        if !Path.user_var.exist?
          shell.say_status 'WARNING',
                           "#{Path.user_var} does not exist",
                           :red
          shell.say_status 'ADVICE',
                           'Try running "idk setup" to configure your environment',
                           :yellow
        elsif !Path.setup_stamp.exist?
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
