# -*- encoding : utf-8 -*-
require 'logger'
require 'action_mailer'

class Turn14BrandDataBuilderAgent
  attr_accessor :options, :errors

  def initialize(options)
    @options = options
    @options
    create_log_file
    establish_db_connection
  end

  def create_log_file
    Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
    $logger = Logger.new("#{File.dirname(__FILE__)}/logs/turn_14_brand_data_builder_agent.log", 'weekly')
    #~ $logger.level = Logger::DEBUG
    $logger.formatter = Logger::Formatter.new
  end

  def establish_db_connection
    # connect to the MySQL server
    get_db_connection(@options[:env])
  end

  def start_processing
    # $site_details["zara_main_url"]
      # begin

        access_token = get_access_token
        if access_token.to_s != ""
          url = URI("#{$site_details['turn_14_all_brand_api_url']}")
          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true
          request = Net::HTTP::Get.new(url)
          request["Authorization"] = "Bearer #{access_token}"
          response = https.request(request)
          response.read_body
           doc = JSON.parse(response.read_body)
           doc["data"].each do |brand|
            puts brand_id = brand["id"] rescue ""
            puts name = brand["attributes"]["name"] rescue ""
            puts dropship = brand["attributes"]["dropship"] rescue false
            puts aaia_code = brand["attributes"]["AAIA"] rescue ""
            puts logo = brand["attributes"]["logo"] rescue ""
            puts full_json = brand rescue ""
            b = Turn14Brand.find_or_initialize_by(:brand_id=>brand_id)
            b.name = name
            b.aaia_code = aaia_code
            b.dropship = dropship
            b.logo = logo
            b.full_json = full_json
            b.save
           end
        end
        
        # puts "Lets start capture"
      # rescue Exception => e
      #   $logger.error "Error Occured #{e}"
      #   $logger.error e.backtrace
      # end
  end #method end 


  def get_access_token
    url = URI("#{$site_details['turn_14_access_token_api_url']}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
     "grant_type": "client_credentials",
     "client_id": "#{$site_details['turn_14_client_id']}",
     "client_secret": "#{$site_details['turn_14_client_secret']}"
    })
    response = https.request(request)
    response.read_body
    json_data = JSON.parse(response.read_body)
    return json_data['access_token']
  end

# 1df5e703b0b2369e607612210ea2d4dfaef519ed

end #class

require 'rubygems'
require 'optparse'
options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: ruby turn_14_brand_data_agent.rb [options]"
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end
  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new turn_14_brand agent for building the turn_14_brand Jobs' ) do |env|
    options[:env] = env
  end
  opts.on( '-h', '--help', 'To get the list of available options' ) do
    opts
    exit
  end
end
optparse.parse!
@options = options
require File.expand_path('../load_configurations', __FILE__)
newprojects_agent = Turn14BrandDataBuilderAgent.new(options)
newprojects_agent.start_processing
