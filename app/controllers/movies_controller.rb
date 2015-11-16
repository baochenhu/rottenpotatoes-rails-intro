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
    if params[:title] && params[:title] == 'sort'
      @movies = Movie.all.order("title ASC")
      @hilite_title = 'hilite'
    elsif params[:release_date] && params[:release_date] == 'sort'
      @movies = Movie.all.order("release_date ASC")
      @hilite_release_date = 'hilite'
    else
      @movies = Movie.where(rating: @checked_ratings.keys)
      session[:ratings] = @checked_ratings
#      @all_ratings.each do |rating|
#        if !@checked_ratings[rating]
#          @checked_ratings[rating] = "false"
#        end
#      end
    end
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
