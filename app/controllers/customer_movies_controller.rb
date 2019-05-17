class CustomerMoviesController < ApplicationController
  def checkout
    customer_movie = CustomerMovie.new(customer_movie_params)
    if customer_movie.save
      checkout_movie = customer_movie.movie.title
      customer_movie.checkout_date = Date.today
      customer_movie.due_date = Date.today.next_week
      customer_movie.movie.inventory -= 1
      customer_movie.save
      customer_movie.movie.save

      render json: {movie: checkout_movie, checkout_date: customer_movie.checkout_date, due_date: customer_movie.due_date},
             status: :ok
    else
      render json: {ok: false, errors: customer_movie.errors.messages},
             status: :bad_request
    end
  end

  def checkin
    customer_movie = CustomerMovie.where(customer_id: customer_movie_params[:customer_id], movie_id: customer_movie_params[:movie_id])
    if customer_movie != []
      customer_movie[0].movie.inventory += 1 # look for the movie id in the array
      customer_movie[0].status = "returned"
      customer_movie[0].movie.save
      customer_movie[0].save

      render json: {movie: customer_movie[0].movie.title, checkin_status: customer_movie[0].status},
             status: :ok
    else
      render json: {ok: false, errors: ["Customer has not checked out this movie"]},
             status: :bad_request
    end
  end

  private

  def customer_movie_params
    params.require(:customer_movie).permit(:customer_id, :movie_id)
  end
end
