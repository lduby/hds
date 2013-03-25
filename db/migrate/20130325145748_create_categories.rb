class CreateCategories < ActiveRecord::Migration
  def change
  	create_table :categories do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    add_column :books, :category_id, :integer
    add_index :books, :category_id
  end
end
