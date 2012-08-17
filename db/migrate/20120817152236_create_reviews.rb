class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :shelf
      t.references :book
      t.integer :rating
      t.text :details
      t.references :child
      t.date :favoriting_date
      t.timestamps
    end
    add_index(:reviews, [ :shelf_id, :book_id ])
    add_index(:reviews, [ :child_id, :book_id ])
  end
end
