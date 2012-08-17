class Review < ActiveRecord::Base
  belongs_to :shelf
  belongs_to :book
  belongs_to :child
  attr_accessible :details, :rating, :shelf_id, :book_id, :child_id, :favoriting_date
end
