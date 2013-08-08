class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings

    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != params[:ratings]
      params[:ratings] = session[:ratings]
      redirect = true
    end
    
    @movies = Movie

    if params[:order]
      session[:order] = params[:order]
    elsif session[:order] != params[:order]
      params[:order] = session[:order]
      redirect = true
    end

    @rating_selection = session[:ratings]
    @order = session[:order]

    if redirect
      redirect_to movies_path(:order => @order, :ratings => @rating_selection)
    else
      @movies = @movies.order(@order)
      if @rating_selection.nil?
        @movies = @movies.all
        @rating_selection = {}
        @all_ratings.each do |rating|
          @rating_selection[rating] = 1
        end
      else
        @movies = @movies.where("rating in (?)", @rating_selection.keys)
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
