require "rubygems"
require 'logger'


Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
$logger = Logger.new("#{File.dirname(__FILE__)}/logs/turn_14_brand_data_monitor.log", 'weekly')
#~ $logger.level = Logger::DEBUG
$logger.formatter = Logger::Formatter.new

pid_status_english = system("ps -aux | grep turn_14_brand_data_agent.rb | grep -vq grep")
if pid_status_english
  $logger.info ("nothing to do....")
else
  $logger.info ("Process started....")
  system("nohup bundle exec ruby /var/www/rv_store/current/agents/turn_14/turn_14_brand_data_agent.rb -e production &")
end
