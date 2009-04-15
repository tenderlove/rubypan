require 'vlad/git'

set :application, 'rubypan'
set :domain, 'rubypan.org'
set :deploy_to, '/data/www/rubypan.org'
set :repository, 'git://github.com/tenderlove/rubypan.git'
 
namespace :vlad do
  remote_task :start_app, :roles => :app do
    run "sudo pkill -TERM -u www -f #{domain}/current/public/dispatch.fcgi"
  end
 
  remote_task :stop_app, :roles => :app # nothing to do
 
  remote_task :update, :roles => :app do
    tmp_dir = File.join latest_release, 'tmp'
    shared_tmp_dir = File.join shared_path, 'tmp'
 
    cmds = [
      "rake -f #{latest_release}/Rakefile prepare",
    ]
 
    run cmds.join(' && ')
  end
end
 
task :deploy => %w[vlad:update vlad:migrate vlad:start_app]
