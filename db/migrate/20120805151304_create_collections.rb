class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.references :publisher
      t.timestamps
    end
    add_index :collections, :publisher_id
  end
end
