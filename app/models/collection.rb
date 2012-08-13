class Collection < ActiveRecord::Base
  validates_length_of :name, :in => 2..255
  validates_uniqueness_of :name
  belongs_to :publisher
  has_many :books
  attr_accessible :name, :publisher_id
end
