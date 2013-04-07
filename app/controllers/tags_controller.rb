class TagsController < ApplicationController
  def show
  	@tag_name = params[:id]
  	@tag_books = Book.tagged_with(params[:id]).by_creation_date
  end
end