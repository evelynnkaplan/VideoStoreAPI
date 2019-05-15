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

  describe "show" do
    it "is a working route and returns JSON" do
      movie = movies(:lucky)
      get movie_path(movie)

      expect(response.header["Content-Type"]).must_include "json"
      must_respond_with :success
    end

    it "returns a hash" do
      movie = movies(:lucky)
      get movie_path(movie)

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
    end

    it "returns an error when looking for a non existing movie" do
      get movie_path(-1)

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash

      must_respond_with :not_found
    end

    it "gets a movie with all the fields in the body" do
      keys = ["id", "title", "overview", "release_date", "inventory"].sort

      movie = movies(:lucky)
      get movie_path(movie)

      body = JSON.parse(response.body)
      body.keys.sort.must_equal keys
    end
  end

  describe "create" do
    let (:movie_data) {
      {
        title: "Lucky Number Sleven",
        overview: "Starts and ends at a bus stop",
        release_date: 2019-05-14,
        inventory: 1,
      }
    }

    it "creates a new movie given valid data" do
      expect {
        post movies_path, params: {movie: movie_data}
      }.must_change "Movie.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"

      movie = Movie.find(body["id"].to_i)

      expect(movie.title).must_equal movie_data[:title]
      must_respond_with :success
    end
  end
end
