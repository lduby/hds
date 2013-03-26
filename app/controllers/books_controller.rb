class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all
    @categories = Category.all
    @themes = Theme.all
    @book_types = BookType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @book_shelf = nil
    if user_signed_in?
      @current_user = current_user
      # Recupération de l'étagère sur laquelle a été rangé le livre
      @book_shelf = @book.shelves.where(:profile_id => current_user.profile.id).first
    end
    
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
    # Getting the selected illustrators
    @book_illustrators = Array.new
    logger.debug("params[:book][:illustrators]")
    logger.debug(params[:book][:illustrators])
    @illustrators_list = params[:book][:illustrators].split(", ");
    logger.debug(@illustrators_list)
    logger.debug(@illustrators_list.size)
    if @illustrators_list.size != 0 
      logger.debug("At least one illustrator has been selected")
      @illustrators_list.each do |illustrator|
        @splitted_illustrator = illustrator.split(" ")
        @illus = illustrator.find_by_first_name_and_last_name(@splitted_illustrator[0],@splitted_illustrator[1])
        if @illus.nil?
          logger.debug("first illustrator does not exist => Creating one !")
          @illus = Illustrator.new(:first_name => @splitted_illustrator[0], :last_name => @splitted_illustrator[1])
          if @illus.save
            logger.debug("illustrator successfully created")
            logger.debug(@illus)
            @book_illustrators << @auth
          else 
            logger.debug("error while creating illustrator")
          end
        else 
          logger.debug("Illustrator found")
          logger.debug("Adding the illustrator")
          @book_illustrators << @illus
        end
      end
    end
    params[:book].delete(:illustrators)
    # Getting the selected publisher
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
      params[:book][:publisher_id] = @publisher.id
      logger.debug("Setting up the publisher id")
      logger.debug(params[:book][:publisher_id])
    end
    # Creating the book
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        # Associating the selected authors 
        if @book_authors.size != 0
          @book_authors.each do |author|
            @book.authors << author
          end
        end
        # Associating the selected illustrators 
        if @book_illustrators.size != 0
          @book_illustrators.each do |illustrator|
            @book.illustrators << illustrator
          end
        end
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
    @to_be_removed_authors = @book.authors - @book_authors
    @to_be_added_authors = @book_authors - (@book.authors & @book_authors)
    logger.debug("Authors to be removed from book: ")
    logger.debug(@to_be_removed_authors)
    logger.debug("Authors to be added to book: ")
    logger.debug(@to_be_added_authors)
    params[:book].delete(:authors)
    # Getting the selected illustrators
    @book_illustrators = Array.new
    logger.debug("params[:book][:illustrators]")
    logger.debug(params[:book][:illustrators])
    @illustrators_list = params[:book][:illustrators].split(", ");
    logger.debug(@illustrators_list)
    logger.debug(@illustrators_list.size)
    if @illustrators_list.size != 0 
      logger.debug("At least one illustrator has been selected")
      @illustrators_list.each do |illustrator|
        @splitted_illustrator = illustrator.split(" ")
        @illus = Illustrator.find_by_first_name_and_last_name(@splitted_illustrator[0],@splitted_illustrator[1])
        if @illus.nil?
          logger.debug("first illustrator does not exist => Creating one !")
          @illus = Illustrator.new(:first_name => @splitted_illustrator[0], :last_name => @splitted_illustrator[1])
          if @illus.save
            logger.debug("illustrator successfully created")
            logger.debug(@illus)
            @book_illustrators << @illus
          else 
            logger.debug("error while creating illustrator")
          end
        else 
          logger.debug("Illustrator found")
          logger.debug("Adding the illustrator")
          @book_illustrators << @illus
        end
      end
    end
    @to_be_removed_illustrators = @book.illustrators - @book_illustrators
    @to_be_added_illustrators = @book_illustrators - (@book.illustrators & @book_illustrators)
    logger.debug("illustrators to be removed from book: ")
    logger.debug(@to_be_removed_illustrators)
    logger.debug("illustrators to be added to book: ")
    logger.debug(@to_be_added_illustrators)
    params[:book].delete(:illustrators)
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
        # Associating the newly selected authors
        if @to_be_added_authors.size != 0
          @to_be_added_authors.each do |book_author|
            @book.authors << book_author
          end
        end
        # Removing the unselected authors
        if @to_be_removed_authors.size != 0
          @to_be_removed_authors.each do |oldauthor|
            @book.authors.delete(oldauthor)
          end
        end
        # Associating the newly selected illustrators
        if @to_be_added_illustrators.size != 0
          @to_be_added_illustrators.each do |book_illustrator|
            @book.illustrators << book_illustrator
          end
        end
        # Removing the unselected illustrators
        if @to_be_removed_illustrators.size != 0
          @to_be_removed_illustrators.each do |oldillustrator|
            @book.illustrators.delete(oldillustrator)
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

  def search_illustrators
    @illustratorslist=Array.new
    Illustrator.all.each do |illustrator|
      @illustratorslist << illustrator.name
    end
    render :json => @illustratorslist
  end
  
end
