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
      get_all_items(access_token, "#{$site_details['turn_14_all_items_api_url']}")
      get_all_data(access_token, "#{$site_details['turn_14_all_data_api_url']}")
      # get_all_items(access_token, "#{$site_details['turn_14_recent_items_api_url']}")
      # get_item_data(access_token)
      
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

  def get_all_items(access_token, url)
    page = 1
    uri = URI(url.gsub('~', page.to_s))
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    response = https.request(request)
    response.read_body
    doc = JSON.parse(response.read_body)
    end_page = doc['meta']['total_pages'].to_i
    while page < end_page  do
      puts "--------------#{page}----------------"
      uri = URI(url.gsub('~', page.to_s))
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{access_token}"
      response = https.request(request)
      response.read_body
      doc = JSON.parse(response.read_body)
      doc["data"].each do |each_prod|
        puts turn14_id = each_prod["id"] rescue ""
        exist_data = Turn14Product.where(:turn14_id => turn14_id)
        if exist_data.empty?
          puts item_type = each_prod["type"] rescue ""
          puts product_name = each_prod["attributes"]['product_name'] rescue ""
          part_number = each_prod["attributes"]['part_number'] rescue ""
          mpn = each_prod["attributes"]['mfr_part_number'] rescue ""
          part_description = each_prod["attributes"]['part_description'] rescue ""
          category = each_prod["attributes"]['category'] rescue ""
          subcategory = each_prod["attributes"]['subcategory'] rescue ""
          box_number = each_prod["attributes"]["dimensions"][0]['box_number'] rescue ""
          length = each_prod["attributes"]["dimensions"][0]['length'] rescue ""
          width = each_prod["attributes"]["dimensions"][0]['width'] rescue ""
          height = each_prod["attributes"]["dimensions"][0]['height'] rescue ""
          weight = each_prod["attributes"]["dimensions"][0]['weight'] rescue ""
          brand_id = each_prod["attributes"]['brand_id'] rescue ""
          brand = each_prod["attributes"]['brand'] rescue ""
          price_group_id = each_prod["attributes"]['price_group_id'] rescue ""
          status = each_prod["attributes"]['active'] rescue ""
          regular_stock = each_prod["attributes"]['regular_stock'] rescue ""
          dropship_controller_id = each_prod["attributes"]['dropship_controller_id'] rescue ""
          air_freight_prohibited = each_prod["attributes"]['air_freight_prohibited'] rescue ""
          not_carb_approved = each_prod["attributes"]['not_carb_approved'] rescue ""
          carb_acknowledgement_required = each_prod["attributes"]['carb_acknowledgement_required'] rescue ""
          ltl_freight_required = each_prod["attributes"]['ltl_freight_required'] rescue ""
          prop_65 = each_prod["attributes"]['prop_65'] rescue ""
          epa = each_prod["attributes"]['epa'] rescue ""
          units_per_sku = each_prod["attributes"]['units_per_sku'] rescue ""
          clearance_item = each_prod["attributes"]['clearance_item'] rescue ""
          barcode = each_prod["attributes"]['barcode'] rescue ""
          Turn14Product.create(:turn14_id => turn14_id, :item_type => item_type, :product_name => product_name, :part_number => part_number, :mpn => mpn, :part_description => part_description, :category => category, :subcategory => subcategory, :box_number => box_number, :length => length, :width => width, :height => height, :weight => weight, :brand_id => brand_id, :brand => brand, :price_group_id => price_group_id, :status => status, :regular_stock => regular_stock, :dropship_controller_id => dropship_controller_id, :air_freight_prohibited => air_freight_prohibited, :not_carb_approved => not_carb_approved, :carb_acknowledgement_required => carb_acknowledgement_required, :ltl_freight_required => ltl_freight_required, :prop_65 => prop_65, :epa => epa, :units_per_sku => units_per_sku, :clearance_item => clearance_item, :barcode => barcode)
        end
      end
      page += 1
    end
  end

  def get_all_data(access_token, url)
    page = 1
    uri = URI(url.gsub('~', page.to_s))
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    response = https.request(request)
    response.read_body
    doc = JSON.parse(response.read_body)
    end_page = doc['meta']['total_pages'].to_i
    while page < end_page  do
      puts "--------------#{page}----------------"
      uri = URI(url.gsub('~', page.to_s))
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{access_token}"
      response = https.request(request)
      response.read_body
      doc = JSON.parse(response.read_body)
      doc["data"].each do |each_prod|
        puts turn14_id = each_prod["id"] rescue ""
        exist_data = Turn14Product.where(:turn14_id => turn14_id)
        if !exist_data.empty?
          image_1 = each_prod['files'][0]['links'][0]['url'] rescue ""
          image_2 = each_prod['files'][1]['links'][0]['url'] rescue ""
          image_3 = each_prod['files'][2]['links'][0]['url'] rescue ""
          image_4 = each_prod['files'][3]['links'][0]['url'] rescue ""
          image_5 = each_prod['files'][4]['links'][0]['url'] rescue ""
          image_6 = each_prod['files'][5]['links'][0]['url'] rescue ""
          image_7 = each_prod['files'][6]['links'][0]['url'] rescue ""
          image_8 = each_prod['files'][7]['links'][0]['url'] rescue ""
          image_9 = each_prod['files'][8]['links'][0]['url'] rescue ""
          image_10 = each_prod['files'][9]['links'][0]['url'] rescue ""
          desc = each_prod['descriptions'][0]['description'] rescue ""
          exist_data.update(:image_1 => image_1, :image_2 => image_2, :image_3 => image_3, :image_4 => image_4, :image_5 => image_5, :image_6 => image_6, :image_7 => image_7, :image_8 => image_8, :image_9 => image_9, :image_10 => image_10, :description => desc, :items_processed => 1)
        end
      end
      page += 1
    end

  end

  def get_item_data(access_token)
    products = Turn14Product.where(:items_processed => 0)
    products.each do |each_data|
      turn14_id = each_prod['turn14_id']
      url = URI("#{$site_details['turn_14_item_data_api_url'].gsub('~', turn14_id)}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Authorization"] = "Bearer #{access_token}"
      response = https.request(request)
      response.read_body
      doc = JSON.parse(response.read_body)
      break if doc['data'].empty?
      doc["data"].each do |each_prod|
        puts turn14_id = each_prod["id"] rescue ""
        image_1 = each_prod['files'][0]['links'][0]['url'] rescue ""
          image_2 = each_prod['files'][1]['links'][0]['url'] rescue ""
          image_3 = each_prod['files'][2]['links'][0]['url'] rescue ""
          image_4 = each_prod['files'][3]['links'][0]['url'] rescue ""
          image_5 = each_prod['files'][4]['links'][0]['url'] rescue ""
          image_6 = each_prod['files'][5]['links'][0]['url'] rescue ""
          image_7 = each_prod['files'][6]['links'][0]['url'] rescue ""
          image_8 = each_prod['files'][7]['links'][0]['url'] rescue ""
          image_9 = each_prod['files'][8]['links'][0]['url'] rescue ""
          image_10 = each_prod['files'][9]['links'][0]['url'] rescue ""
          desc = each_prod['descriptions'][0]['description'] rescue ""
          each_data.update(:image_1 => image_1, :image_2 => image_2, :image_3 => image_3, :image_4 => image_4, :image_5 => image_5, :image_6 => image_6, :image_7 => image_7, :image_8 => image_8, :image_9 => image_9, :image_10 => image_10, :description => desc, :items_processed => 1)
      end
    end
  end
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
