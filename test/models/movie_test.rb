require "test_helper"

describe Movie do
  let(:movie) { movies(:lucky) }

  it "must be valid" do
    value(movie).must_be :valid?
  end

  it "will save with a title and inventory" do
    new_movie = Movie.new(title: "Lucky", inventory: 11)

    expect {
      new_movie.save
    }.must_change "Movie.count", 1
  end

  it "won't save without a title" do
    new_movie = Movie.new(inventory: 11)

    expect {
      new_movie.save
    }.wont_change "Movie.count"
  end

  it "won't save without an inventory" do
    new_movie = Movie.new(title: "Lucky")

    expect {
      new_movie.save
    }.wont_change "Movie.count"
  end
end
