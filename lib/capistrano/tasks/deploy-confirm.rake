include Capistrano::Deploy::Confirm

before :deploy, "deploy:confirm"

namespace :deploy do
  desc "Should we really deploy?"
  task :confirm do
    if fetch(:this_is_live) == true
      on release_roles :all do |host|
        run_locally do
            execute :git, :fetch, :origin
          end

          # fetch current revision and revision to be deployed
          from = from_rev
          to = to_rev

          # if there is nothing to deploy on this host, inform the user
          if from == to
            info "\e[0;31mNo changes to deploy on #{host} (from and to are the same: #{from} -> #{to})\e[0m"
          else
            run_locally do
              header = "\e[0;90mChanges pending deployment on #{host} (#{from} -> #{to}):\e[0m\n"

              # capture log of commits between current revision and revision for deploy
              output = capture :git, :log, "#{from}..#{to}", '--pretty="format:%C(yellow)%h %Cblue%>(12)%ai %Cgreen%<(7)%aN%Cred%d %Creset%s"'

              # if we get no results, flip refs to look at reverse log in case of rollback deployments
              if output.to_s.strip.empty?
                output = capture :git, :log, "#{to}..#{from}", '--pretty="format:%C(yellow)%h %Cblue%>(12)%ai %Cgreen%<(7)%aN%Cred%d %Creset%s"'
                if not output.to_s.strip.empty?
                  header += "\e[0;31mWarning: It appears you may be going backwards in time on #{host} with this deployment!\e[0m\n"
                end
              end

              # write pending changes log
              (header + output).each_line do |line|
                info line
              end
          end

          ask :goodtogo, "You are about to deploy the master branch to live. Type 'yes' to continue"
          if fetch(:goodtogo) == "yes"
            puts "You got it buddy. Imma deploy now."
          else
            puts "Whoa whoa whoa! Ok. Good thing I asked!"
            puts "Stopping!"
            exit
          end
        end
      end
    end
  end
end