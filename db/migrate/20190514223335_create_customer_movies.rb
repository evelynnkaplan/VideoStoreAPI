class CreateCustomerMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :customer_movies do |t|
      
      t.timestamps
    end
  end
end
