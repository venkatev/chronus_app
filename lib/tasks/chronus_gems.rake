namespace :chronus_gems do
  desc "Installs all required gems for this application."
  task :install do
    require 'rubygems'
    require 'rubygems/gem_runner'

    $rails_gem_installer = true
    begin
      Rake::Task[:environment].invoke
    rescue
      puts "Errors while loading the environment. IGNORING...."
    end
    Rails.configuration.gems.each { |gem| gem.install unless gem.loaded? }
  end
end