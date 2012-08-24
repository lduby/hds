class Profile < ActiveRecord::Base
  belongs_to :user 
  has_many :shelves, :dependent => :destroy
  has_many :children
  attr_accessible :last_name, :first_name, :city, :country, :age, :user_id
    
  def name
    "#{first_name} #{last_name}"
  end

  def average_rating  	
  	@shelves_id = Array.new()
  	@conditions = "shelf_id IN ("
  	shelves.each do |s| 
  	  if s == shelves.first
  		@conditions << s.id.to_s
  	  else
  	  	@conditions << ", "+s.id.to_s
  	  end
  	end
  	@conditions << ") AND details IS NOT NULL"
    Review.average(:rating, :conditions => @conditions)
  end

  def ratings_count
  	@shelves_id = Array.new()
  	@conditions = "shelf_id IN ("
  	shelves.each do |s| 
  	  if s == shelves.first
  		@conditions << s.id.to_s
  	  else
  	  	@conditions << ", "+s.id.to_s
  	  end
  	end
  	@conditions << ") AND details IS NOT NULL"
    Review.count(:rating, :conditions => @conditions)
  end

  def reviews_count
  	@shelves_id = Array.new()
  	@conditions = "shelf_id IN ("
  	shelves.each do |s| 
  	  if s == shelves.first
  		@conditions << s.id.to_s
  	  else
  	  	@conditions << ", "+s.id.to_s
  	  end
  	end
  	@conditions << ") AND details IS NOT NULL"
    Review.count(:id, :conditions => @conditions)
  end
end
