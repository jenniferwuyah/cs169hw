class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings].present?
        @selected_ratings = params[:ratings]
    elsif session[:ratings].present?
    	@selected_ratings = session[:ratings]
   	redirect = true
    else
	@selected_ratings = Hash[@all_ratings.map {|x| [x, 1]}]
    end
    session[:ratings] = @selected_ratings

    if params[:sort].present?
        @sort_by = params[:sort]
    elsif session[:sort].present?
        @sort_by = session[:sort]
	redirect = true
    end
    session[:sort] = @sort_by if @sort_by.present?
    
    if redirect
        flash.keep
        redirect_to movies_path :sort => @sort_by, :ratings => @selected_ratings
    end

    @movies = Movie.where(:rating => @selected_ratings.keys)
    @movies = @movies.order(@sort_by) if @sort_by.present?
    
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
