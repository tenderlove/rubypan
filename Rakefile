# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
require 'texticle/tasks'

task :prepare do
  basename = File.join RAILS_ROOT, 'config', 'database.yml'
  cp "#{basename}.default", basename unless File.exist? basename
 
  dispatch_fcgi = File.join RAILS_ROOT, 'public', 'dispatch.fcgi'
 
  unless File.exist? dispatch_fcgi then
    require 'rbconfig'
    c = Config::CONFIG
    ruby = File.join c['bindir'], "#{c['ruby_install_name']}#{c['EXEEXT']}"
 
    File.open dispatch_fcgi, 'w' do |fp|
      text = File.read "#{dispatch_fcgi}.default"
      fp.write text.sub(/\A#!.*$/, "#!#{ruby}")
    end
 
    File.chmod 0755, dispatch_fcgi
  end
end
 
require 'vlad'
 
Vlad.load :app => nil, :config => File.join(RAILS_ROOT, 'config', 'deploy.rb')
