class BookTypesController < ApplicationController
  # GET /book_types
  # GET /book_types.json
  def index
    @book_types = BookType.all
    @new_book_type = BookType.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @book_types }
    end
  end

  # GET /book_types/1
  # GET /book_types/1.json
  def show
    @book_type = BookType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book_type }
    end
  end

  # GET /book_types/new
  # GET /book_types/new.json
  def new
    @book_type = BookType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book_type }
    end
  end

  # GET /book_types/1/edit
  def edit
    @book_type = BookType.find(params[:id])
  end

  # POST /book_types
  # POST /book_types.json
  def create
    @book_type = BookType.new(params[:book_type])
   
    respond_to do |format|
      if @book_type.save
        format.html { redirect_to '/book_types', notice: 'Book Type was successfully created.' }
        format.json { render json: @book_type, status: :created, location: @book_types }
      else
        format.html { redirect_to '/book_types', errors: 'Book Type could not be created.' }
        format.json { render json: @book_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /book_types/1
  # PUT /book_types/1.json
  def update
    @book_type = BookType.find(params[:id])

    respond_to do |format|
      if @book_type.update_attributes(params[:book_type])
        format.html { redirect_to @book_type, notice: 'Book Type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_types/1
  # DELETE /book_types/1.json
  def destroy
    @book_type = BookType.find(params[:id])
    @book_type.destroy

    respond_to do |format|
      format.html { redirect_to book_types_url }
      format.json { head :no_content }
    end
  end
end
