class BooksController < ApplicationController
  #include HTTParty
  require 'open-uri'
  require 'date'

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
    @categories = Category.joins(:books).group("category_id")
    @themes = Theme.joins(:books).group("theme_id")
    @book_types = BookType.all
    @tags = Book.tag_counts_on(:tags)

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
    @tags_list = ""
    @book.tags.each do |t|
      if t == @book.tags.first
        @tags_list << "#{t.name}"
      else 
        @tags_list << ",#{t.name}"
      end
    end
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
    # Getting the selected collection
    logger.debug("params[:book][:collection_id]")
    logger.debug(params[:book][:collection_id])
    @collection = Collection.find_by_name(params[:book][:collection_id])
    if @collection.nil?
      logger.debug("collection does not exist => Creating one !")
      if !@publisher.nil? 
        @collection = @publisher.collections.create(:name => params[:book][:collection_id])
        if @collection.save
          logger.debug("collection successfully created")
          logger.debug(@collection)
          params[:book][:collection_id] = @collection.id
        else 
          logger.debug("error while creating collection")
          params[:book][:collection_id] = ""
          logger.debug("Deleting the collection id")
          logger.debug(params[:book][:collection_id])
        end
      else
        # TBD : actions if the no publisher created and a collection was provided
      end
    else 
      logger.debug("Collection found")
      params[:book][:collection_id] = @collection.id
      logger.debug("Setting up the collection id")
      logger.debug(params[:book][:collection_id])
    end
    # Getting the selected tags
    logger.debug("params[:book][:tags]")
    logger.debug(params[:book][:tags])
    if params[:book][:tags] 
      @tags_list = params[:book][:tags].delete("[").delete("\"").delete("]")
    end
    logger.debug(@tags_list)
    params[:book].delete(:tags)
    # Getting the selected themes
    @book_themes = Array.new
    logger.debug("params[:book][:themes]")
    logger.debug(params[:book][:themes])
    @themes_list = params[:book][:themes].split(", ")
    logger.debug(@themes_list)
    logger.debug(@themes_list.size)
    if @themes_list.size != 0 
      logger.debug("At least one theme has been selected")
      @themes_list.each do |theme|
        @thm = Theme.find_by_name(theme)
        if @thm.nil?
          logger.debug("theme does not exist => Creating one !")
          @thm = Theme.new(:name => theme)
          if @thm.save
            logger.debug("theme successfully created")
            logger.debug(@thm)
            @book_themes << @thm
          else 
            logger.debug("error while creating theme")
          end
        else 
          logger.debug("Theme found")
          logger.debug("Adding the theme")
          @book_themes << @thm
        end
      end
    end
    params[:book].delete(:themes)
    # Creating the book
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        @msg = 'Book was successfully created'
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
        # Associating the selected tags 
        if !@tags_list.nil?
          @book.tag_list = @tags_list
          if @book.save
            @msg << " and tagged"
          else 
            @msg << " but not tagged"
          end
        end
        # Associating the selected themes 
        if @book_themes.size != 0
          @book_themes.each do |theme|
            @book.themes << theme
          end
        end
        format.html { redirect_to @book, notice: @msg }
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
    # tags
    if params[:book][:tags] 
      @tags_list = params[:book][:tags].delete("[").delete("\"").delete("]")
    end
    logger.debug(@tags_list)
    params[:book].delete(:tags)
    # Getting the selected themes
    @book_themes = Array.new
    logger.debug("params[:book][:themes]")
    logger.debug(params[:book][:themes])
    @themes_list = params[:book][:themes].split(", ");
    logger.debug(@themes_list)
    logger.debug(@themes_list.size)
    if @themes_list.size != 0 
      logger.debug("At least one theme has been selected")
      @themes_list.each do |theme|
        @thm = Theme.find_by_name(theme)
        if @thm.nil?
          logger.debug("theme does not exist => Creating one !")
          @thm = Theme.new(:name => theme)
          if @thm.save
            logger.debug("theme successfully created")
            logger.debug(@thm)
            @book_themes << @thm
          else 
            logger.debug("error while creating theme")
          end
        else 
          logger.debug("Theme found")
          logger.debug("Adding the theme")
          @book_themes << @thm
        end
      end
    end
    @to_be_removed_themes = @book.themes - @book_themes
    @to_be_added_themes = @book_themes - (@book.themes & @book_themes)
    logger.debug("themes to be removed from book: ")
    logger.debug(@to_be_removed_themes)
    logger.debug("themes to be added to book: ")
    logger.debug(@to_be_added_themes)
    params[:book].delete(:themes)
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
    # Getting the selected collection
    logger.debug("params[:book][:collection_id]")
    logger.debug(params[:book][:collection_id])
    if params[:book][:collection_id] != ""
      @collection = Collection.find_by_name(params[:book][:collection_id])
      if @collection.nil?
        logger.debug("collection does not exist => Creating one !")
        if !@publisher.nil?
          @collection = @publisher.collections.create(:name => params[:book][:collection_id])
          if @collection.save
            logger.debug("collection successfully created")
            logger.debug(@collection)
            params[:book][:collection_id] = @collection.id
          else 
            logger.debug("error while creating collection")
            params[:book][:collection_id] = ""
            logger.debug("Deleting the collection id")
            logger.debug(params[:book][:collection_id])
          end
        else
          # TBD Actions when no publisher for a new collection
        end
      else 
        logger.debug("Collection found")
        params[:book][:collection_id] = @collection.id
        logger.debug("Setting up the collection id")
        logger.debug(params[:book][:collection_id])
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
	# Associating the selected tags 
        if !@tags_list.nil?
          @book.tag_list = @tags_list
          if @book.save
            logger.debug "Book tagged"
          else 
            logger.debug "Book not tagged"
          end
        end
        # Associating the newly selected themes
        if @to_be_added_themes.size != 0
          @to_be_added_themes.each do |book_theme|
            @book.themes << book_theme
          end
        end
        # Removing the unselected themes
        if @to_be_removed_themes.size != 0
          @to_be_removed_themes.each do |oldtheme|
            @book.themes.delete(oldtheme)
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

  def search_themes
    @themeslist=Array.new
    Theme.all.each do |theme|
      @themeslist << theme.name
    end
    render :json => @themeslist
  end

  def search_tags
    @tags = Book.tag_counts_on(:tags)
    render :json => @tags
  end

  def tag_cloud
    @tags = Book.tag_counts_on(:tags)
  end

  def search_for
    logger.debug(params)
    #@response = HTTParty.get('http://openisbn.com/isbn/'+params['isbn'])
    ### OpenISBN
    # @doc = Nokogiri::HTML(open('http://openisbn.com/isbn/'+params['isbn'])) 
    # @title = @doc.css('.Articles h1').inner_text
    # @img_url = @doc.css('.PostContent img')[0]['src']
    # @details = @doc.xpath('//div[@class="Article"]//div[@class="PostContent"]/text()')
    # @details_splitted = @details.to_s.split('<BR>')
    # logger.debug(@title)
    # logger.debug(@img_url)
    # logger.debug(@details_splitted.to_s)
    ### Amazon Search
    @amazon_url = 'http://www.amazon.fr/s/ref=nb_sb_noss?field-keywords='+params['isbn']
    logger.debug(@amazon_url)
    @doc = Nokogiri::HTML(open(@amazon_url))
    @book_link = @doc.xpath('//div[@class="productTitle"]/a[@href]')
    @book_url = @book_link[0]['href'].to_s
    if !@book_link.empty?
      logger.debug(@book_url)
      ### Amazon book page parsing
      @book_doc = Nokogiri::HTML(open(@book_url))
      @book_asin_title = @book_doc.xpath('//h1[@class="parseasinTitle"]//span[@id="btAsinTitle"]')
      @book_title = @book_asin_title.inner_text.squish.sub(/ \[.*\]/,'')
      @book_authors = @book_doc.xpath('//div[@class="buying"]/a')
      @book_buying = @book_doc.xpath('//div[@id="ps-content"]//div[@class="buying"]/span')
      @book_published_at = @book_buying[1].inner_text
      @book_collection = @book_buying[3].inner_text.squish
      @book_description = @book_doc.xpath('//div[@id="postBodyPS"]//div')
      @book_details = @book_doc.xpath('//table//div[@class="content"]/ul/li/text()')
      @book_pagescount = @book_details[0].inner_text.to_s.squish.chomp(" pages")
      @book_publisher = @book_details[1].inner_text.to_s.squish.sub(/ \(.*\)/,'')
      #@book_collection = @book_details[2].inner_text.to_s.squish
      #logger.debug(@book_collection)
      @book_language = @book_details[3].inner_text.to_s.squish
      @book_isbn10 = @book_details[4].inner_text.to_s.squish
      @book_isbn13 = @book_details[5].inner_text.to_s.squish
      ### Creating an object to send via JSON
      @book = Hash.new
      @book["title"] = @book_title
      case @book_authors.size 
      when 1
        @book["authors"] = @book_authors[0].inner_text
      when 2
        @book["authors"] = @book_authors[0].inner_text
        @book["illustrators"] = @book_authors[1].inner_text
      else
        @book_authors.each do |author|
          if author != @book_authors.last
            if author == @book_authors.first
              @book_authors_list << author.inner_text
            else
              @book_authors_list << ", " + author.inner_text
            end
          end
        end
        @book["authors"] = @book_authors_list
        @book["illustrators"] = @book_authors.last.inner_text
      end 
      @publishing_date = DateTime.parse(@book_published_at)
      @formatted_publishing_date = @publishing_date.strftime("%Y-%m-%d")
      @book["published_at"] = @formatted_publishing_date
      @book["collection"] = @book_collection
      @book["description"] = @book_description.inner_text
      @book["pages"] = @book_pagescount
      @book["publisher"] = @book_publisher
      @book["language"] = @book_language
      @book["isbn10"] = @book_isbn10
      @book["isbn13"] = @book_isbn13
      logger.debug(@book.to_s)
    end

    # logger.debug(@response.code)
    # logger.debug(@response.message)
    # logger.debug(@response.headers.inspect)

    render :json => @book
  end
  
end
