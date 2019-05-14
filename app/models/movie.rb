class Movie < ApplicationRecord
  has_many :customer_movies
  has_many :customers, through: :customer_movies
  validates :title, presence: true
  validates :inventory, presence: true, numericality: {greater_than: -1}
end
