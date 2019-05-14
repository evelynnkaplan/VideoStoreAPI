require_relative "../test_helper"

describe Customer do
  let(:customer) { customers(:myriam) }

  describe "validations" do
    it "must be valid" do
      value(customer).must_be :valid?
    end

    it "will save with a name" do
      new_cust = Customer.new(name: "Sarah")

      expect {
        new_cust.save
      }.must_change "Customer.count", 1
    end

    it "won't save without a name" do
      new_cust = Customer.new

      expect {
        new_cust.save
      }.wont_change "Customer.count"

      expect(new_cust.errors.messages).must_include :name
    end
  end

  describe "relations" do
    it "can add a customer/movie relationship" do
      customer = customers(:myriam)
      movie = movies(:lucky)

      customer.movies << movie

      expect(customer.movies).must_include movie
      expect(movie.customers).must_include customer
    end

    # it "bad test" do
    #   customer = customers(:myriam)
    #   movie = Movie.new(title: "new", inventory: 1)

    #   customer.movies << movie
    #   # customer.save

    #   expect(customer.movies).wont_include movie
    #   # expect(customer.movies.errors.messages).must_include :title
    # end
  end
end
