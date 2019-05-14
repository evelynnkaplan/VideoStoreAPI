require "test_helper"

describe CustomerMovie do
  let(:customer_movie) { CustomerMovie.new(customer: Customer.first, movie: Movie.first) }

  it "must be valid" do
    # customer = customers(:evelynn)
    # movie = movies(:lion_king)
    # customer.customer_movie = customer
    # # customer_movie.movie = movie

    value(customer_movie).must_be :valid?
  end

  describe "relations" do
    it "can add a customer/movie relationship" do
      customer = customers(:myriam)
      movie = movies(:lucky)

      relationship = CustomerMovie.new(customer: customer, movie: movie)

      expect { relationship.save }.must_change "CustomerMovie.count", 1
      expect(relationship.customer_id).must_equal customer.id
      expect(relationship.movie_id).must_equal movie.id
    end

    it "can't add a customer/movie relationship if there is not a customer" do
      movie = movies(:lucky)

      relationship = CustomerMovie.new(movie: movie)

      expect { relationship.save }.wont_change "CustomerMovie.count"
      expect(relationship.errors.messages).must_include :customer
    end

    it "can't add a customer/movie relationship if there is not a movie" do
      customer = customers(:evelynn)

      relationship = CustomerMovie.new(customer: customer)

      expect { relationship.save }.wont_change "CustomerMovie.count"
      expect(relationship.errors.messages).must_include :movie
    end
  end
end
