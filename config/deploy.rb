set :application, "fititgame"
set :domain,      "fititgame.com"
set :repository,  "git://www.github.com/saschagehlich/fitit.git"
set :user,        "fititgame"
set :env,         "production" unless exists?(:env)
set :port,        23222
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, "master" unless exists?(:branch)

set :deploy_to,   "/home/#{user}/#{env}"
set :use_sudo,    false

ssh_options[:forward_agent] = true
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 0

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Refresh shared node_modules symlink to current node_modules"
  
  desc "Install node modules non-globally"
  task :npm_install do
    run "cd #{current_path}; npm install; forever stopall; NODE_ENV=production forever start -c coffee index.coffee"
  end
end

after "deploy:symlink", "deploy:npm_install"