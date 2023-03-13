class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
    	t.string :upc
    	t.string :rva_id
    	t.string :product_name
    	t.string :part_number
    	t.string :mpn
    	t.string :category
    	t.string :subcategory
    	t.string :brand
    	t.string :stock
    	t.string :price
    	t.string :turn14_id
    	t.string :turn14_stock
    	t.string :turn14_price
    	t.string :wps_stock
    	t.string :wps_price
    	t.string :total_stock
    	t.string :total_price
		t.timestamps
    end
    add_reference :products, :category
    add_reference :products, :sub_category
  end
end
