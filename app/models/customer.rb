class Customer < ApplicationRecord
  has_many :customer_movies
  has_many :movies, through: :customer_movies
  validates :name, presence: true
end
