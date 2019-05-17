class AddStatusToCustomerMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :customer_movies, :status, :string
  end
end
