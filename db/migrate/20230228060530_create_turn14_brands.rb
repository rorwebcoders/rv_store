class CreateTurn14Brands < ActiveRecord::Migration[6.1]
  def change
    create_table :turn14_brands do |t|
      t.string :brand_id
      t.string :name
      t.string :aaia_code
      t.boolean :dropship
      t.text :logo
      t.text :full_json
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end
  end
end
