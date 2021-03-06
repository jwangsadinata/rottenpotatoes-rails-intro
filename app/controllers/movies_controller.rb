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
    @all_ratings = Movie.all_ratings
    @selected_ratings = @all_ratings if @selected_ratings.nil?
    
    if session[:sort_by] != params[:sort_by] and !params[:ratings].nil?
      session[:sort_by] = params[:sort_by]
    end
    if session[:ratings] != params[:ratings] and !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    if params[:sort_by].nil? && params[:ratings].nil? && (!session[:sort_by].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    end
    @sort_by_instance = session[:sort_by]
    @ratings_instance = session[:ratings]
    if session[:ratings].nil?
      ratings = Movie.all_ratings

    else
      ratings = @ratings_instance.keys
    end
    @selected_ratings = ratings
    if @sort_by_instance.nil?
      @movies = Movie.where(rating: ratings)
    else
      begin
        @movies = Movie.order("#{@sort_by_instance} ASC").where(rating: ratings)
      rescue ActiveRecord::StatementInvalid
        flash[:warning] = "Movies cannot be sorted by this order"
        @movies = Movie.where(rating: ratings)
      end
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
