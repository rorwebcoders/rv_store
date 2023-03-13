class CreateCategorySubCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :category_sub_categories do |t|
    	t.references :category, index: true
	    t.references :sub_category, index: true
	    t.timestamps
    end
  end
end
