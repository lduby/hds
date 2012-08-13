class Book < ActiveRecord::Base
  belongs_to :publisher 
  belongs_to :collection
  has_and_belongs_to_many :authors
  attr_accessible :title, :publisher_id, :published_at, :collection_id, :isbn10, :isbn13, :page_count, :edition_language, :original_title, :price, :min_age, :max_age, :publisher_resume, :cover_url
end
