class CreateBookTypes < ActiveRecord::Migration
  def change
  	create_table :book_types do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    add_column :books, :type_id, :integer
    add_index :books, :type_id
  end
end
