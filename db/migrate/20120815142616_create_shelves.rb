class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.string :name
      t.text :description
      t.references :profile
      t.timestamps
    end
    add_index :shelves, :profile_id
  end
end
