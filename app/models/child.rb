class Child < ActiveRecord::Base
  belongs_to :profile 
  has_many :books, :through => :reviews
  attr_accessible :birth_date, :first_name
end
