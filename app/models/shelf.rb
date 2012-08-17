class Shelf < ActiveRecord::Base
  belongs_to :profile
  has_many :reviews
  has_many :books, :through => :reviews
  attr_accessible :description, :name
end
