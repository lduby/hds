module BooksHelper
  def render_shelf_selection_form_for(user)
    @in_my_library = false
    user.profile.shelves.each do |shelf|
      if shelf.books.include?(self)
        @in_my_library = true 
        break
      end
    end
    if !@in_my_library
      render "books/select_shelf"
    else 
      render "books/change_shelf"
    end
  end
end
