class FollowsController < ApplicationController
  
  def create
    # Getting the id of the user matching the name
    logger.debug(params[:followable])
    @splitted_user = params[:followable].split(" ")
    logger.debug(@splitted_user)
    @profile = Profile.find_by_first_name_and_last_name(@splitted_user[0],@splitted_user[1])
    logger.debug(@profile)
    @followable = @profile.user
    logger.debug(@followable.email)
    @follower = User.find(params[:follower])
    logger.debug(@follower.email)
    @follow = @follower.follow(@followable)
    if @follow.save
      flash[:notice] = "You are now following one more user."
      redirect_to user_profile_path(@followable,@followable.profile)
    else
      flash[:error] = "Unable to follow this user."
      redirect_to root_url
    end
  end

  def destroy
    @followable = User.find(params[:followable])
    current_user.stop_following(params[:followable])
    flash[:notice] = "You are no longer following this user."
    redirect_to user_profile_path(current_user,current_user.profile)
  end


end
