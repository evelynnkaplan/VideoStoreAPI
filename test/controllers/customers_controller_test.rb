require "test_helper"

describe CustomersController do
  describe "index" do
    it "is a working route and returns JSON" do
      get customers_path

      expect(response.header["Content-Type"]).must_include "json"
      must_respond_with :success
    end

    it "returns an array" do
      get customers_path

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all of the customers" do
      get customers_path

      body = JSON.parse(response.body)
      body.length.must_equal Customer.count
    end

    it "gets a list of customers with all the fields in the body" do
      keys = ["id", "name", "registered_at", "postal_code", "phone"].sort

      get customers_path

      body = JSON.parse(response.body)

      body.each do |customer|
        customer.keys.sort.must_equal keys
      end
    end
  end
end
