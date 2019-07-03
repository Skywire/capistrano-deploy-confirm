before :deploy, "deploy:confirm"
namespace :deploy do
  desc "Should we really deploy?"
  task :confirm do
    if fetch(:this_is_live) == true
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