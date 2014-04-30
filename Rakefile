# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'resque/tasks'
EySample::Application.load_tasks

task "resque:setup" => :environment do
    ENV['QUEUE'] ||= '*'
    #for redistogo on heroku http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedl
     Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end
