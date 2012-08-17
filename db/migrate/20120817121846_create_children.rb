class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.references :profile
      t.string :first_name
      t.date :birth_date
      t.timestamps
    end
    add_index :children, :profile_id
  end
end
