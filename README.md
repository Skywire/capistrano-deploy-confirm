# Deploy Confirm

- Gem to confirm before deploying to live

## Add to your project:

Add the following to your project Gemfile

~~~
gem 'capistrano-deploy-confirm', :git => 'git@github.com:Skywire/capistrano-deploy-confirm.git', :branch => 'master'
~~~

Then run 

~~~
bundle install
~~~

Add the following to your project Capfile

~~~
require "capistrano/deploy-confirm"
~~~

## Configuration

In the live/production staging file add the following configuration:

~~~
set :this_is_live, true
~~~