class Book < ActiveRecord::Base
  belongs_to :publisher 
  belongs_to :collection
  belongs_to :category
  belongs_to :type
  has_many :reviews
  has_many :shelves, :through => :reviews
  has_many :children, :through => :reviews
  has_and_belongs_to_many :themes
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :illustrators
  attr_accessible :title, :publisher_id, :published_at, :collection_id, :isbn10, :isbn13, :page_count, :edition_language, :original_title, :price, :category_id, :publisher_resume, :cover
  has_attached_file :cover, :default_url => "/images/medium/missing.png", :styles => { :medium => "300x300>", :tiny => "128x128>", :thumb => "100x100>", :bookblock => "400x300#" }, :default_url => "/images/:style/missing.png"
  acts_as_taggable
  acts_as_taggable_on :tags
  scope :by_creation_date, order("created_at DESC")
  

  def authors_list
    @list = "";
    authors.each do |a|
      if a == authors.first
        @list << "#{a.name}"
      else 
        @list << ", #{a.name}"
      end
    end
    @list
  end

  def illustrators_list
    @list = ""
    illustrators.each do |i|
      if i == illustrators.first
        @list << "#{i.name}"
      else 
        @list << ", #{i.name}"
      end
    end
    @list
  end

  def themes_list
    @list = ""
    themes.each do |t|
      if t == themes.first
        @list << "#{t.name}"
      else 
        @list << ", #{t.name}"
      end
    end
    @list
  end

  def tags_list
    @list = ""
    tags.each do |t|
      if t == tags.first
        @list << "#{t.name}"
      else 
        @list << ", #{t.name}"
      end
    end
    @list
  end

  def reviews_count
    Review.count(:id, :conditions => ['book_id = ? AND details IS NOT NULL', self.id])
  end

  def ratings_count
    Review.count(:rating, :conditions => ['book_id = ? AND rating IS NOT NULL', self.id])
  end

  def average_rating
    Review.average(:rating, :conditions => ['book_id = ? AND rating IS NOT NULL', self.id])
  end

  def current_user_review
    reviews.each do |review|
      if review.shelf.profile == @current_user.profile
        @review = review
      end
    end
    @review
  end
end
