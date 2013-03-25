class BookType < ActiveRecord::Base
  validates_length_of :name, :in => 2..255
  validates_uniqueness_of :name
  has_many :books
  attr_accessible :name, :description
end