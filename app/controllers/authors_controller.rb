class AuthorsController < ApplicationController
  def index
    @authors = Author.paginate(
      :page       => params[:page],
      :include    => [:ruby_gems => :releases],
      :order      => 'name'
    )
  end

  def show
    @author = Author.find(params[:id])
    @title = @author.name
  end
end
