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
    begin
			access_token = get_access_token
	    if access_token.to_s != ""
	      get_stock(access_token)
	      get_pricing(access_token)
	    end
	rescue Exception => e
      $logger.error "Error Occured #{e}"
      $logger.error e.backtrace
    end
  end #method end


  def get_access_token # to fetch access token
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

  def get_stock(access_token) # get inventory for all item
  	begin
  		page = 1
	    uri = URI($site_details['turn_14_stock_api_url'].gsub('~', page.to_s))
	    https = Net::HTTP.new(uri.host, uri.port)
	    https.use_ssl = true
	    request = Net::HTTP::Get.new(uri)
	    request["Authorization"] = "Bearer #{access_token}"
	    response = https.request(request)
	    response.read_body
	    doc = JSON.parse(response.read_body)
	    end_page = doc['meta']['total_pages'].to_i
	    while page < end_page  do
	    	begin
	    		puts "--------------#{page}----------------"
		      uri = URI($site_details['turn_14_stock_api_url'].gsub('~', page.to_s))
		      https = Net::HTTP.new(uri.host, uri.port)
		      https.use_ssl = true
		      request = Net::HTTP::Get.new(uri)
		      request["Authorization"] = "Bearer #{access_token}"
		      response = https.request(request)
		      response.read_body
		      doc = JSON.parse(response.read_body)
		      doc["data"].each do |each_prod|
		      	begin
		      		$logger.info turn14_id = each_prod["id"] rescue ""
			        exist_data = Turn14Product.where(:turn14_id => turn14_id)
			        if !exist_data.empty?
			          inventory_01 = each_prod['attributes']['inventory']['01'] rescue ''
			          inventory_02 = each_prod['attributes']['inventory']['02'] rescue ''
			          inventory_59 = each_prod['attributes']['inventory']['59'] rescue ''
			          total_inventory = inventory_01.to_i + inventory_02.to_i + inventory_59.to_i rescue ''
			          exist_data.update(:inventory_01 => inventory_01, :inventory_02 => inventory_02, :inventory_59 => inventory_59, :total_inventory => total_inventory)
			        end
		      	rescue Exception => e
		      		$logger.error "Error Occured in getting details in product #{turn14_id} -- #{e}"
      				$logger.error e.backtrace
		      	end
		      end
	    	rescue Exception => e
	    		$logger.error "Error Occured in getting details in page #{page} -- #{e}"
      		$logger.error e.backtrace
	    	end
	      page += 1
	    end
  	rescue Exception => e
  		$logger.error "Error Occured in getting details #{e}"
      $logger.error e.backtrace
  	end
  end # method end

  def get_pricing(access_token) # get price for all item
  	begin
  		page = 1
	    uri = URI($site_details['turn_14_pricing_api_url'].gsub('~', page.to_s))
	    https = Net::HTTP.new(uri.host, uri.port)
	    https.use_ssl = true
	    request = Net::HTTP::Get.new(uri)
	    request["Authorization"] = "Bearer #{access_token}"
	    response = https.request(request)
	    response.read_body
	    doc = JSON.parse(response.read_body)
	    end_page = doc['meta']['total_pages'].to_i
	    while page < end_page  do
	    	begin
	    		puts "--------------#{page}----------------"
		      uri = URI($site_details['turn_14_pricing_api_url'].gsub('~', page.to_s))
		      https = Net::HTTP.new(uri.host, uri.port)
		      https.use_ssl = true
		      request = Net::HTTP::Get.new(uri)
		      request["Authorization"] = "Bearer #{access_token}"
		      response = https.request(request)
		      response.read_body
		      doc = JSON.parse(response.read_body)
		      doc["data"].each do |each_prod|
		      	begin
		      		$logger.info turn14_id = each_prod["id"] rescue ""
			        exist_data = Turn14Product.where(:turn14_id => turn14_id)
			        if !exist_data.empty?
			         	jobber_price = each_prod['attributes']['pricelists'].find{|e| e['name'] == 'Jobber'}['price'] rescue ''
			         	map_price = each_prod['attributes']['pricelists'].find{|e| e['name'] == 'MAP'}['price'] rescue ''
			         	dealer_price = each_prod['attributes']['pricelists'].find{|e| e['name'] == 'Dealer'}['price'] rescue ''
			         	retail_price = each_prod['attributes']['pricelists'].find{|e| e['name'] == 'Retail'}['price'] rescue ''
			         	purchase_cost = each_prod['attributes']['purchase_cost'] rescue ''
			         	exist_data.update(:jobber_price => jobber_price, :map_price => map_price, :dealer_price => dealer_price, :retail_price => retail_price, :purchase_cost => purchase_cost)
			        end
		      	rescue Exception => e
		      		$logger.error "Error Occured in getting details in product #{turn14_id} -- #{e}"
      				$logger.error e.backtrace
		      	end
		      end
	    	rescue Exception => e
	    		$logger.error "Error Occured in getting details in page #{page} -- #{e}"
      		$logger.error e.backtrace
	    	end
	      page += 1
	    end
  	rescue Exception => e
  		$logger.error "Error Occured in getting details #{e}"
      $logger.error e.backtrace
  	end
  end # method end
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
