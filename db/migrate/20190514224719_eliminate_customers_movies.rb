class EliminateCustomersMovies < ActiveRecord::Migration[5.2]
  def change
    drop_table :customers_movies
  end
end
