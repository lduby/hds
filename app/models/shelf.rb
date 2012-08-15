class Shelf < ActiveRecord::Base
  belongs_to :profile
  attr_accessible :description, :name
end
