class Child < ActiveRecord::Base
  belongs_to :profile 
  attr_accessible :birth_date, :first_name
end
