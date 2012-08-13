class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.profile.nil?
        logger.debug(current_user.id)
        @profile = current_user.build_profile()
        if @profile.save
          logger.debug("Profile created")
          redirect_to edit_profile_path(@profile)
        else
          logger.debug("Profile not created")
        end
      end
    end
  end
end
