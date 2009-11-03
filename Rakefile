require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin; require 'metric_fu'; rescue LoadError; end

task :cleandb => :environment do
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke
end

task :cleandbtest do
  RAILS_ENV = ENV['RAILS_ENV'] = "test"
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke
end

desc "Stop a sphinx process if its running"
namespace :ts do
  task :stop_if_running => :environment do
    Rake::Task["ts:stop"].invoke if sphinx_running?
  end
end
