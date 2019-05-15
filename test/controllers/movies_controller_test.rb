require "test_helper"

describe MoviesController do
  describe "index" do
    it "is a working route and returns JSON" do
      get movies_path

      expect(response.header["Content-Type"]).must_include "json"
      must_respond_with :success
    end

    it "returns an array" do
      get movies_path

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all of the movies" do
      get movies_path

      body = JSON.parse(response.body)
      body.length.must_equal Movie.count
    end

    it "gets a list of movies with all the fields in the body" do
      keys = ["id", "title", "release_date"].sort

      get movies_path

      body = JSON.parse(response.body)

      body.each do |movie|
        movie.keys.sort.must_equal keys
      end
    end
  end
end
