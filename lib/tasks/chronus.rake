namespace :chronus do
  PLUGIN_LIST = {
    :assert_packager => 'git://github.com/sbecker/asset_packager.git',
    :crummy => 'git://github.com/zachinglis/crummy.git',
    :flash_manager => 'git://github.com/venkatev/feature_manager.git',
    :flash_notification => 'git://github.com/venkatev/flash_notification.git',
    :back_mark => 'git://github.com/venkatev/back_mark.git',
    :exception_notification => 'git://github.com/rails/exception_notification.git',
    :open_id_authentication => 'git://github.com/rails/open_id_authentication.git',
    :nested_scopes => 'git://github.com/venkatev/nested_scopes.git',
    :restful_authentication => 'git://github.com/technoweenie/restful-authentication.git',
    :acts_as_state_machine => 'http://elitists.textdriven.com/svn/plugins/acts_as_state_machine/trunk'
  }
  
  desc 'List all plugins available to quick install'
  task :plugins do
    puts "\nAvailable Plugins\n=================\n\n"
    plugins = PLUGIN_LIST.keys.sort_by { |k| k.to_s }.map { |key| [key, PLUGIN_LIST[key]] }
    
    plugins.each do |plugin|
      puts "#{plugin.first.to_s.gsub('_', ' ').capitalize.ljust(30)} rake chronus:plugins:#{plugin.first.to_s}\n"
    end
    puts "\n"
  end
  
  namespace :plugins do
    PLUGIN_LIST.each_pair do |key, value|
      task key do
        system('script/plugin', 'install', value, '--force')
      end
    end
  end
end
