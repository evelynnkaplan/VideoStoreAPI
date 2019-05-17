class CustomerMovie < ApplicationRecord
  belongs_to :customer
  belongs_to :movie

  def self.checkout_movie(customer_movie_params)
    customer_movie = CustomerMovie.new(customer_movie_params)

    if customer_movie.save
      checkout_movie = customer_movie.movie.title
      customer_movie.checkout_date = Date.today
      customer_movie.due_date = Date.today.next_week
      customer_movie.movie.inventory -= 1
      customer_movie.save
      customer_movie.movie.save
      return customer_movie
    else
      return nil
    end
  end

  def self.find_rentals(customer_movie_params)
    customer_movie = CustomerMovie.where(customer_id: customer_movie_params[:customer_id], movie_id: customer_movie_params[:movie_id])
    if customer_movie != []
      customer_movie[0].movie.inventory += 1
      customer_movie[0].status = "returned"
      customer_movie[0].movie.save
      customer_movie[0].save
    end
    return customer_movie[0]
  end
end
