class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    @shelf = Shelf.find(params[:shelf_id])
    @book = Book.find(params[:book_id])
    @review = Review.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @shelf = Shelf.find(params[:shelf_id])
    @book = Book.find(params[:book_id])
    @review = @book.reviews.create(params[:review])
    
    respond_to do |format|
      if @review.save
        if @shelf.name != "to_read"
          format.html { redirect_to @book, notice: 'Review was successfully created and Book was added to shelf.' }
          format.json { render json: @review, status: :created, location: @review }
        else         
          format.html { redirect_to @book, notice: 'Book was successfully marked as to_read.' }
          format.json { render json: @review, status: :created, location: @review }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.json
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end
  
  def select_shelf
    @book = Book.find(params[:book_id])
    @shelf = Shelf.find(params[:shelf_id])
    # Creation de la review 
    @review = @book.reviews.create(:shelf_id => @shelf.id)
    if @review.save 
      respond_to do |format|
        if @shelf.name != "to_read"
          format.html { redirect_to edit_review_path(@review), notice: 'Book was successfully marked as read and added to your library. Please give us at least a rating. ' }
          format.json { render json: @review, status: :created, location: @review }
        else
          format.html { redirect_to @book, notice: 'Book was successfully marked as to_read.' }
          format.json { render json: @review, status: :created, location: @review }
        end
      end
    else 
      respond_to do |format|
        format.html { render action: "select_shelf" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def change_shelf
    @book = Book.find(params[:book_id])
    @old_shelf = Shelf.find(params[:old_shelf_id])
    @new_shelf = Shelf.find(params[:new_shelf_id])
    @review = Review.find_by_book_and_shelf(params[:book_id],params[:old_shelf_id])
    if @shelf.name != "to_read"
      # Changing the shelf reference without changing rating, details or children favoriting link
      @review.shelf = @new.shelf
      if @review.save
        respond_to do |format|
          format.html { redirect_to @book, notice: 'Book was successfully changed of shelf.' }
          format.json { render json: @review, status: :updated_shelf, location: @review }
        end
      else
        respond_to do |format|
          format.html { render action: "change_shelf" }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    else
      # Changing the shelf reference and redirecting to edit form to give a rating and optionnally some details
      @review.shelf = @new_shelf
      if @review.save 
        respond_to do |format|
          format.html { redirect_to edit_review_path(@review), notice: 'Book was successfully marked as read and added to your library. Please give us at least a rating. ' }
          format.json { render json: @review, status: :updated_shelf, location: @review }
        end
      else
        respond_to do |format|
          format.html { render action: "change_shelf" }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
