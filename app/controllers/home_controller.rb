class HomeController < ApplicationController
  def index
    @books = Book.all
    @last_entries = Book.order("created_at DESC").limit(10)
    @most_reviewed = Book.all(:select => "books.*, COUNT(book_id) as reviews_count",
            :joins  => "LEFT JOIN reviews AS reviews ON reviews.book_id = books.id",
            :group  => "reviews.book_id",
            :order  => "reviews_count DESC",
            :conditions  => "reviews.details IS NOT NULL",
            :limit => 5)
    @populars = Book.all(:select => "books.*, AVG(rating) as average_rating",
            :joins  => "LEFT JOIN reviews AS reviews ON reviews.book_id = books.id",
            :group  => "reviews.book_id",
            :order  => "average_rating DESC",
            :conditions  => "reviews.rating IS NOT NULL",
            :limit => 5)
    #@coup_coeur = Book.order("created_at DESC").limit(10)

    @tags = Book.tag_counts_on(:tags)
    @last_reviews = Review.all(:conditions => "details IS NOT NULL", :order => "created_at DESC", :limit => 5)

    if user_signed_in?
      if current_user.profile.nil?
        logger.debug(current_user.id)
        @profile = current_user.build_profile()
        if @profile.save
          logger.debug("Profile created")
          redirect_to edit_user_profile_path(current_user,@profile)
        else
          logger.debug("Profile not created")
        end
      end
    end
  end
end
