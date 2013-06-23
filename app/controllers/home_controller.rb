class HomeController < ApplicationController
  def index
    @books = Book.all
    @last_entries = Book.order("created_at DESC").limit(10)
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
