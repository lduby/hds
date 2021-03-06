class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    # Creating the default shelves if they don't exist
    if @profile.shelves.size == 0
      @def_shelf_1 = @profile.shelves.build(:name => "to_read")
      if @def_shelf_1.save
        logger.debug("Shelf to_read auto created")
      end
      @def_shelf_2 = @profile.shelves.build(:name => "read")
      if @def_shelf_2.save
        logger.debug("Shelf read auto created")
      end
      @def_shelf_3 = @profile.shelves.build(:name => "currently_reading")
      if @def_shelf_3.save
        logger.debug("Shelf currently_reading auto created")
      end
    end
    # Getting all the books added to shelves 
    @shelves = @profile.shelves
    @all_shelves_books = Array.new
    if !@shelves.empty?
      @shelves.each do |shelf|
        if !shelf.books.empty?
          shelf.books.each do |book|
            @all_shelves_books << book
          end
        end
      end
    end
    # Getting all the reviews written by the profile user
    @user_reviews = Array.new
    if !@profile.shelves.empty?
      @profile.shelves.each do |shelf|
        shelf.reviews.each do |review|
          if !review.details.nil?
            @user_reviews << review
          end
        end
      end
    end 

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end
  def edit
    @profile = Profile.find(params[:id])
    @user = @profile.user
    if @profile.shelves.size == 0
      @def_shelf_1 = @profile.shelves.build(:name => "to_read")
      if @def_shelf_1.save
        logger.debug("Shelf to_read auto created")
      end
      @def_shelf_2 = @profile.shelves.build(:name => "read")
      if @def_shelf_2.save
        logger.debug("Shelf read auto created")
      end
      @def_shelf_3 = @profile.shelves.build(:name => "currently_reading")
      if @def_shelf_3.save
        logger.debug("Shelf currently_reading auto created")
      end
    end
  end
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to user_profile_path(@profile.user,@profile), notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def search_followable_users
    logger.debug("Search for followable_users")
    @followable_users_list=Array.new
    User.all.each do |user|
      if user != current_user
        @followable_users_list << user.profile.name
      end
    end
    render :json => @followable_users_list
  end

end
