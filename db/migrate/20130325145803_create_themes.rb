class CreateThemes < ActiveRecord::Migration
  def change
  	create_table :themes do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    create_table :books_themes, :id => false do |t|
      t.references :book, :theme
    end

  end
end
