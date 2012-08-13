class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end
  def edit
    @profile = Profile.find(params[:id])
  end
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
end
