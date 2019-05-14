class Movie < ApplicationRecord
  has_and_belongs_to_many :customers
  validates :title, presence: true
  validates :inventory, presence: true, numericality: {greater_than: -1}
end
