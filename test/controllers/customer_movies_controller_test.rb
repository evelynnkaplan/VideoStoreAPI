require "test_helper"

describe CustomerMoviesController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  describe "checkout" do
    it "creates a new instance of customer movie" do
      # increases count of CustomerMovies
      # decrease inventory of associated movie
      # set's checkout date to today
      # calculates due date to 7 days from today - model method

      customer = customers(:evelynn)
      movie = movies(:lion_king)
      movie_inventory = movie.inventory
      checkout_data = {
        customer_id: customer.id,
        movie_id: movie.id,
      }
      expect { post checkout_path, params: {customer_movie: checkout_data} }.must_change "CustomerMovie.count", 1
      expect(movie.inventory).must_equal movie_inventory - 1
      expect(CustomerMovie.last.checkout_date).must_equal Date.today
      expect(CustomerMovie.last.due_date).must_equal Date.today.next_week
    end

    it "returns an error for invalid data" do
      customer = customers(:evelynn)
      checkout_data = {
        customer: customer,
      }
      expect { post checkout_path, params: {checkout: checkout_data} }.wont_change "CustomerMovie.count"
      expect(body).must_be_kind_of Hash
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "movie"
      must_respond_with :bad_request
    end
  end
end
