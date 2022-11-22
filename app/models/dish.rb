class Dish < ApplicationRecord
  # belongs_to :day_dish
  has_many :ingredients, through: :dish_ingredients
  validates :name, presence: true
end
