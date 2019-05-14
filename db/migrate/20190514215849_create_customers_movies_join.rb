class CreateCustomersMoviesJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :customers_movies do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :movie, index: true
      t.date :checkout_date
      t.date :due_date
    end
  end
end
