require "bundler/capistrano"

set :application, "Preroller"
set :scm, :git
set :repository,  "git@github.com:SCPR/Preroller.git"
set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache

set :deploy_to, "/web/preroller"
set :rails_env, :production
set :user, "preroller"
set :use_sudo, false

role :app, "media.scpr.org"
role :web, "media.scpr.org"
role :db,  "media.scpr.org", :primary => true

task :staging do
  roles.clear
  set :rails_env, :scprdev
  set :branch, "master"
  role :app, "scprdev.org"
  role :web, "scprdev.org"
  role :db,  "scprdev.org", :primary => true
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
