set_default(:wordpress_db_name) { "#{application.gsub(/-/,'_')}" }
set_default(:wordpress_db_user) { Capistrano::CLI.ui.ask "Wordpress DB User: " }
set_default(:wordpress_db_password) { Capistrano::CLI.password_prompt "Wordpress DB Password: " }
set_default(:wordpress_db_host, "localhost")
set_default(:wordpress_db_charset, "utf8")
set_default(:wordpress_db_collate, "") 
set_default(:wordpress_security_keys) { `curl -L https://api.wordpress.org/secret-key/1.1/salt/` }
set_default(:wordpress_table_prefix, "wp_")
set_default(:wordpress_wplang, "")
set_default(:wordpress_wp_debug, "false")

namespace :wordpress do
  desc "Generate the wp-config.php configuration file."
  task :setup, :roles => :web do
    template "wp-config.php.erb", "#{shared_path}/wp-config.php"
  end
  after "deploy:setup", "wordpress:setup"

  desc "Symlink the wp-config.php configuration file"
  task :symlink, :roles => :web do
    run "#{sudo} ln -nfs #{shared_path}/wp-config.php #{release_path}/wp-config.php"
  end
  after "deploy:finalize_update", "wordpress:symlink"

  desc "Create a database for this application."
  task :create_database, :roles => :web do
    mysql "create database #{wordpress_db_name};"
    mysql "grant all on #{wordpress_db_name}.* to '#{wordpress_db_user}'@'#{wordpress_db_host}' identified by '#{wordpress_db_password}'; flush privileges;"
  end
  after "wordpress:setup", "wordpress:create_database"
end
