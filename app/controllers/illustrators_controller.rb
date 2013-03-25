class IllustratorsController < ApplicationController
  # GET /illustrators
  # GET /illustrators.json
  def index
    @illustrators = Illustrator.all
    @new_illustrator = Illustrator.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @illustrators }
    end
  end

  # GET /illustrators/1
  # GET /illustrators/1.json
  def show
    @illustrator = Illustrator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @illustrator }
    end
  end

  # GET /illustrators/new
  # GET /illustrators/new.json
  def new
    @illustrator = Illustrator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @illustrator }
    end
  end

  # GET /illustrators/1/edit
  def edit
    @illustrator = Illustrator.find(params[:id])
  end

  # POST /illustrators
  # POST /illustrators.json
  def create
    @illustrator = Illustrator.new(params[:illustrator])
   
    respond_to do |format|
      if @illustrator.save
        format.html { redirect_to '/illustrators', notice: 'Illustrator was successfully created.' }
        format.json { render json: @illustrator, status: :created, location: @illustrators }
      else
        format.html { redirect_to '/illustrators', errors: 'Illustrator could not be created.' }
        format.json { render json: @illustrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /illustrators/1
  # PUT /illustrators/1.json
  def update
    @illustrator = Illustrator.find(params[:id])

    respond_to do |format|
      if @illustrator.update_attributes(params[:illustrator])
        format.html { redirect_to @illustrator, notice: 'Illustrator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @illustrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /illustrators/1
  # DELETE /illustrators/1.json
  def destroy
    @illustrator = Illustrator.find(params[:id])
    @illustrator.destroy

    respond_to do |format|
      format.html { redirect_to illustrators_url }
      format.json { head :no_content }
    end
  end
end
