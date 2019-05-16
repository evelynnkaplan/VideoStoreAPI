require "test_helper"

describe CustomerMoviesController do
  describe "checkout" do
    it "creates a new instance of customer movie" do
      customer = customers(:evelynn)
      movie = Movie.create(title: "Wow", overview: "Amazing!", release_date: "2019-05-14", inventory: 5)
      movie_inventory = movie.inventory
      checkout_data = {
        customer_id: customer.id,
        movie_id: movie.id,
      }

      expect { post checkout_path, params: {customer_movie: checkout_data} }.must_change "CustomerMovie.count", 1

      after_checkout = Movie.find_by(id: CustomerMovie.last.movie.id)

      expect(after_checkout.inventory).must_equal movie_inventory - 1
      expect(CustomerMovie.last.checkout_date).must_equal Date.today
      expect(CustomerMovie.last.due_date).must_equal Date.today.next_week
    end

    it "returns an error for invalid data" do
      customer = customers(:evelynn)
      checkout_data = {
        customer: customer,
      }

      expect { post checkout_path, params: {customer_movie: checkout_data} }.wont_change "CustomerMovie.count"

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "movie"
      must_respond_with :bad_request
    end
  end

  describe "check-in" do
    it "find the customer movie entry and return the inventory to the movie" do
      customer = customers(:evelynn)
      movie = Movie.create(title: "Wow", overview: "Amazing!", release_date: "2019-05-14", inventory: 5)
      movie_inventory = movie.inventory
      checkout_data = {
        customer_id: customer.id,
        movie_id: movie.id,
      }

      post checkout_path, params: {customer_movie: checkout_data}

      after_checkout = Movie.find_by(id: CustomerMovie.last.movie.id)

      checkin_data = {
        customer_id: customer.id,
        movie_id: movie.id,
      }

      post checkin_path, params: {customer_movie: checkin_data}

      after_checkin = Movie.find_by(id: CustomerMovie.last.movie.id)

      expect(after_checkin.inventory).must_equal after_checkout.inventory + 1
      expect(CustomerMovie.last.status).must_equal "returned"
    end

    it "returns an error for invalid data at checkin" do
      customer = customers(:evelynn)
      checkin_data = {
        customer: customer,
      }

      post checkin_path, params: {customer_movie: checkin_data}

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "movie"
      must_respond_with :bad_request
    end
  end
end
