class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :title, :release_date]), status: :ok
  end

  def show
    movie = Movie.find_by(id: params[:id])
    if !movie.nil?
      render json: movie.as_json(only: [:id, :title, :overview, :release_date, :inventory]), status: :ok
    else
      render json: {ok: false, message: ["Movie not found"]}, status: :not_found
    end
  end

  def movie_params
  end
end
