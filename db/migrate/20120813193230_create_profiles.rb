class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :last_name
      t.string :first_name
      t.string :city
      t.string :country
      t.integer :age
      t.timestamps
    end
  end
end
