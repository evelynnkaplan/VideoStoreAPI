class CustomerMoviesController < ApplicationController
  def checkout
    rental = CustomerMovie.checkout_movie(customer_movie_params)

    if rental != nil
      render json: {movie: rental, checkout_date: rental.checkout_date, due_date: rental.due_date},
             status: :ok
    else
      render json: {ok: false, errors: ["Couldn't rent the movie"]},
             status: :bad_request
    end
  end

  def checkin
    rental = CustomerMovie.find_rentals(customer_movie_params)

    if rental != nil
      render json: {movie: rental.movie.title, checkin_status: rental.status},
             status: :ok
    else
      render json: {ok: false, errors: ["Customer has not checked out this movie"]},
             status: :bad_request
    end

    #     customer_movie = CustomerMovie.new(customer_movie_params)
    #     if customer_movie.save
    #       checkout_movie = customer_movie.movie.title
    #       customer_movie.checkout_date = Date.today
    #       customer_movie.due_date = Date.today.next_week
    #       customer_movie.movie.inventory -= 1
    #       customer_movie.save
    #       customer_movie.movie.save

    #       render json: {movie: checkout_movie, checkout_date: customer_movie.checkout_date, due_date: customer_movie.due_date},
    #              status: :ok
    #     else
    #       render json: {ok: false, errors: customer_movie.errors.messages},
    #              status: :bad_request
    #     end
    #   end

    #   def checkin
    #     rental = CustomerMovie.find_rentals(customer_movie_params)

    #     if rental != nil
    #       render json: {movie: rental.movie.title, checkin_status: rental.status},
    #              status: :ok
    #     else
    #       render json: {ok: false, errors: ["Customer has not checked out this movie"]},
    #              status: :bad_request
    #     end
  end

  private

  def customer_movie_params
    params.require(:customer_movie).permit(:customer_id, :movie_id)
  end
end
