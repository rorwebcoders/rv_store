class Product < ApplicationRecord
	belongs_to :category
	belongs_to :sub_category
	after_save :update_stock, :update_price
	def update_stock
		if saved_change_to_attribute?(:turn14_stock)
			temp_stock = self.turn14_stock.to_i + self.wps_stock.to_i
			puts self.total_stock = temp_stock
		end
		if saved_change_to_attribute?(:wps_stock)
			temp_stock = self.turn14_stock.to_i + self.wps_stock.to_i
			puts self.total_stock = temp_stock
		end
	end
	def update_price
		if saved_change_to_attribute?(:turn14_price)
			temp_price = self.turn14_price.to_i + self.wps_price.to_i
			puts self.total_price = temp_price
		end
		if saved_change_to_attribute?(:wps_price)
			temp_price = self.turn14_price.to_i + self.wps_price.to_i
			puts self.total_price = temp_price
		end
	end
end
