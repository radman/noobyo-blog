require "capistrano_colors"
require "erb"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/mysql"
load "config/recipes/wordpress"

server "23.21.115.207", :app, :web, :db
set :application, "noobyo-blog"

# redirection settings
set :nginx_redirect_server_names, "blog.evayin.com .nuubly.com .newcomer101.com .newcomers101.com .vancouvernewcomers.com"
set :nginx_redirect_to, "blog.noobyo.com"

# main address (should include at least the redirect_to address above)
set :nginx_server_name, ".noobyo.com"

set :user, "deployer"
set :group, "www-data"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository, "git@github.com:radman/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true # for password prompts
ssh_options[:forward_agent] = true # forward local ssh keys to server (make sure you've used ssh-add for each key you want to forward)

after "deploy", "deploy:cleanup" # keep only the last 5 releases
