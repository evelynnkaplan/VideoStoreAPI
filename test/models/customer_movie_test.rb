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

  describe "checkout_movie" do
    it "checks out a movie with good data" do
      movie = Movie.create(title: "Wow", overview: "Amazing!", release_date: "2019-05-14", inventory: 5)
      movie_inventory = movie.inventory

      CustomerMovie.checkout_movie({
        customer: customers(:evelynn),
        movie: movie,
      })

      after_checkout = Movie.find_by(id: CustomerMovie.last.movie.id)

      expect(after_checkout.inventory).must_equal movie_inventory - 1
      expect(CustomerMovie.last.checkout_date).must_equal Date.today
      expect(CustomerMovie.last.due_date).must_equal Date.today.next_week
    end

    it "returns nil if given bad data" do
      customer = customers(:evelynn)

      rental = CustomerMovie.checkout_movie({
        customer: customer,
      })

      expect(rental).must_equal nil
    end
  end

  describe "find_rentals" do
    it "will check in a movie given good data" do
      customer = customers(:evelynn)
      movie = Movie.create(title: "Wow", overview: "Amazing!", release_date: "2019-05-14", inventory: 5)
      movie_inventory = movie.inventory
      checkout_data = {
        customer_id: customer.id,
        movie_id: movie.id,
      }

      CustomerMovie.checkout_movie({
        customer: customers(:evelynn),
        movie: movie,
      })

      after_checkout = Movie.find_by(id: CustomerMovie.last.movie.id)

      checkin_data = {
        customer_id: customer.id,
        movie_id: movie.id,
      }

      CustomerMovie.find_rentals(checkin_data)

      after_checkin = Movie.find_by(id: CustomerMovie.last.movie.id)

      expect(after_checkin.inventory).must_equal after_checkout.inventory + 1
      expect(CustomerMovie.last.status).must_equal "returned"
    end

    it "will return nil if given bad data" do
      customer = customers(:evelynn)
      checkin_data = {
        customer: customer,
      }

      after_checkin = CustomerMovie.find_rentals(checkin_data)

      expect(after_checkin).must_equal nil
    end
  end
end
