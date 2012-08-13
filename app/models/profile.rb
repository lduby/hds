class Profile < ActiveRecord::Base
  belongs_to :user 
  has_many :shelves
  attr_accessible :last_name, :first_name, :city, :country, :age, :user_id
    
  def name
    "#{first_name} #{last_name}"
  end
end
