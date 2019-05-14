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
    
  end
end
