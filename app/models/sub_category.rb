class SubCategory < ApplicationRecord
	has_many :category
	has_many :product
	before_create :create_slug
	def create_slug
	slug_temp = self.name.to_s.strip().downcase.gsub(".","").gsub("'","").gsub('"',"").gsub('%',"").gsub('&',"").gsub('*',"").gsub('/',"").gsub("(","").gsub(")","").gsub(",","").gsub("  "," ").gsub(" ","-").squeeze("--","-").to_s.strip()
	self.slug = "remote-"+slug_temp+"-jobs"
	end
end
