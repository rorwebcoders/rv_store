class CreateCategoriesSubcategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
  	create_join_table :categories, :sub_categories do |t|
    t.index :category_id
    t.index :sub_category_id
  end
  end
end
