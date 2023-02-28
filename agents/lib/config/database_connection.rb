# -*- encoding : utf-8 -*-
require 'yaml'
# connect to the MySQL server
def get_db_connection(env)
  $db_connection_established = false
  site_config = YAML::load(File.open(File.expand_path("../../../lib/config/site_properties.yml", __FILE__)))
  db_config = YAML::load(File.open(File.expand_path("../../../../config/database.yml", __FILE__)))
  $AGENT_ENV = env
  config = db_config[env]
  $site_details = site_config[env]
  begin
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection
    $db_connection_established = true
    $logger.info 'Mysql connection established'
  rescue Exception => e
    puts "Error code: #{e.inspect}"
    $logger.error "Error code: #{e}"
  end
end
