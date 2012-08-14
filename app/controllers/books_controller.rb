class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new
    @publishers = Publisher.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    logger.debug("params[:book][:publisher_id]")
    logger.debug(params[:book][:publisher_id])
    @publisher = Publisher.find_by_name(params[:book][:publisher_id])
    if @publisher.nil?
      logger.debug("publisher does not exist => Creating one !")
      @publisher = Publisher.new(:name => params[:book][:publisher_id])
      if @publisher.save
        logger.debug("publisher successfully created")
        logger.debug(@publisher)
        params[:book][:publisher_id] = @publisher.id
      else 
        logger.debug("error while creating publisher")
        params[:book][:publisher_id] = ""
        logger.debug("Deleting the publisher id")
        logger.debug(params[:book][:publisher_id])
      end
    else 
      logger.debug("Publisher found")
      logger.debug(@publisher.to_array.to_s)
      params[:book][:publisher_id] = @publisher.id
      logger.debug("Setting up the publisher id")
      logger.debug(params[:book][:publisher_id])
    end
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    # Getting the book which is to be updated 
    @book = Book.find(params[:id])
    # Getting the selected authors
    @book_authors = Array.new
    logger.debug("params[:book][:authors]")
    logger.debug(params[:book][:authors])
    @authors_list = params[:book][:authors].split(", ");
    logger.debug(@authors_list)
    logger.debug(@authors_list.size)
    if @authors_list.size != 0 
      logger.debug("At least one author has been selected")
      @authors_list.each do |author|
        @splitted_author = author.split(" ")
        @auth = Author.find_by_first_name_and_last_name(@splitted_author[0],@splitted_author[1])
        if @auth.nil?
          logger.debug("first author does not exist => Creating one !")
          @auth = Author.new(:first_name => @splitted_author[0], :last_name => @splitted_author[1])
          if @auth.save
            logger.debug("author successfully created")
            logger.debug(@auth)
            @book_authors << @auth
          else 
            logger.debug("error while creating author")
          end
        else 
          logger.debug("Author found")
          logger.debug("Adding the author")
          @book_authors << @auth
        end
      end
    end
    params[:book].delete(:authors)
    # Getting the selected publisher
    logger.debug("params[:book][:publisher_id]")
    logger.debug(params[:book][:publisher_id])
    if params[:book][:publisher_id] != ""
      @publisher = Publisher.find_by_name(params[:book][:publisher_id])
      if @publisher.nil?
        logger.debug("publisher does not exist => Creating one !")
        @publisher = Publisher.new(:name => params[:book][:publisher_id])
        if @publisher.save
          logger.debug("publisher successfully created")
          logger.debug(@publisher)
          params[:book][:publisher_id] = @publisher.id
        else 
          logger.debug("error while creating publisher")
          params[:book][:publisher_id] = ""
          logger.debug("Deleting the publisher id")
          logger.debug(params[:book][:publisher_id])
        end
      else 
        logger.debug("Publisher found")
        params[:book][:publisher_id] = @publisher.id
        logger.debug("Setting up the publisher id")
        logger.debug(params[:book][:publisher_id])
      end
    end
    logger.debug("Updating the attribute with params[:book]")
    logger.debug(params[:book])
    # Updating the book
    respond_to do |format|
      if @book.update_attributes(params[:book])
        # Associating the author
        if @book_authors.size != 0
          @book_authors.each do |book_author|
            @book.authors << book_author
          end
        end
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
  
  def search_publishers
    @publisherslist=Array.new
    Publisher.all.each do |publisher|
      @publisherslist << publisher.name
    end
    render :json => @publisherslist
  end
  
  def search_authors
    @authorslist=Array.new
    Author.all.each do |author|
      @authorslist << author.name
    end
    render :json => @authorslist
  end
  
end
