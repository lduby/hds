class Child < ActiveRecord::Base
  belongs_to :profile 
  has_many :books, :through => :reviews
  attr_accessible :birth_date, :first_name

  def age
  	now = Time.now.utc.to_date
  	now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end
end
