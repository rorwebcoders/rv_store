# -*- encoding : utf-8 -*-
require 'rubygems'
require 'logger'
require 'active_record'
require 'optparse'
require 'nokogiri'
require 'watir'
require 'mysql2'
require 'headless'
require 'net/ftp'
require 'net/http'
require 'uri'
require 'open-uri'
require 'rest-client'
require 'json'


ActiveRecord::Base.default_timezone = :utc
require File.expand_path('../../lib/config/database_connection', __FILE__)
require File.expand_path('../../../config/application', __FILE__)
require File.expand_path('../../../app/models/application_record', __FILE__)
require File.expand_path('../../../app/models/turn14_brand', __FILE__)
require File.expand_path('../../../app/models/turn14_product', __FILE__)




