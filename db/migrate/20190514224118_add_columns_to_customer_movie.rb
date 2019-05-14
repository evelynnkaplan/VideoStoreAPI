class AddColumnsToCustomerMovie < ActiveRecord::Migration[5.2]
  def change
    add_reference :customer_movies, :customer, foreign_key: true
    add_reference :customer_movies, :movie, foreign_key: true
    add_column :customer_movies, :checkout_date, :date 
    add_column :customer_movies, :due_date, :date
  end
end
