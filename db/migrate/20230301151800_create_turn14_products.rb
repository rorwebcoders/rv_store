class CreateTurn14Products < ActiveRecord::Migration[6.1]
  def change
    create_table :turn14_products do |t|
    	t.string :turn14_id
    	t.string :item_type
    	t.string :product_name
    	t.string :part_number
    	t.string :mpn
    	t.text :part_description
    	t.string :category
    	t.string :subcategory
    	t.string :box_number
    	t.string :length
    	t.string :width
    	t.string :height
    	t.string :weight
    	t.string :brand_id
    	t.string :brand
    	t.string :price_group_id
    	t.boolean :status
    	t.boolean :regular_stock
    	t.string :dropship_controller_id
    	t.boolean :air_freight_prohibited
    	t.boolean :not_carb_approved
    	t.boolean :carb_acknowledgement_required
    	t.boolean :ltl_freight_required
    	t.string :prop_65
    	t.string :epa
    	t.string :units_per_sku
    	t.boolean :clearance_item
    	t.string :barcode
    	t.string :items_processed
        t.string :image_1
        t.string :image_2
        t.string :image_3
        t.string :image_4
        t.string :image_5
        t.string :image_6
        t.string :image_7
        t.string :image_8
        t.string :image_9
        t.string :image_10
        t.longtext :description
        t.string :inventory_01
        t.string :inventory_02
        t.string :inventory_59
        t.string :total_inventory
        t.string :map_price
        t.string :dealer_price
        t.string :jobber_price
        t.string :retail_price
        t.string :purchase_cost
        t.timestamps
    end
  end
end
