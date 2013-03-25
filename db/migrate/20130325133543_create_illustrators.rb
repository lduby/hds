class CreateIllustrators < ActiveRecord::Migration
  def change
  	create_table :illustrators do |t|
      t.string :first_name
      t.string :last_name
      t.timestamps
    end

    create_table :books_illustrators, :id => false do |t|
      t.references :book, :illustrator
    end
  end
end
