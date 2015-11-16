class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   # @movies = Movie.all
    @checked_ratings = params[:ratings]
    @checked_ratings_from_session = session[:ratings]
    if !@checked_ratings && !@checked_ratings_from_session
      @checked_ratings = {'G' => true,'PG' => true, 'PG-13'=> true, 'R' => true}
    elsif @checked_ratings_from_session && !@checked_ratings
      @checked_ratings = @checked_ratings_from_session
    end
   
    @all_ratings = Movie.all_ratings
    if !params[:sort] && session[:sort]
      params[:sort] = session[:sort]
      redirect_to :sort => params[:sort]
    end
    if  params[:sort] == 'title'
      @movies = Movie.where(rating: @checked_ratings.keys).order("title ASC")
      @hilite_title = 'hilite'
      session[:sort] = 'title'
    elsif params[:sort] == 'release_date'
      @movies = Movie.where(rating: @checked_ratings.keys).order("release_date ASC")
      @hilite_release_date = 'hilite'
      session[:sort] = 'release_date'
    else
      @movies = Movie.where(rating: @checked_ratings.keys)
    end
    session[:ratings] = @checked_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
