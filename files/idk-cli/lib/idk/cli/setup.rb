require 'thor'
require 'idk/cli/actions'

module IDK
  module CLI
    class Setup < Thor::Group
      include Actions

      "Set up development environment"

      def user
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

        if ENV['idk_rvm_path']
          create_link File.join(ENV['idk_rvm_path'], 'hooks', 'after_use_idk'),
                      profile_sh
        end

        create_file Path.setup_stamp
      end

      def system
        inside '/opt/idk/solo' do
          run 'chef-solo -c solo.rb -j dna.json', with: 'sudo'
          fatal! 'chef-solo failed' unless $?.success?
        end
      end

      def final_notice
        shell.say_status 'Finished.', "Now run `source /opt/idk/profile.sh' or log out and log in again", :green
      end
    end
  end
end
