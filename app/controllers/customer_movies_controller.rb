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

  private

  def customer_movie_params
    params.require(:customer_movie).permit(:customer_id, :movie_id)
  end
end
