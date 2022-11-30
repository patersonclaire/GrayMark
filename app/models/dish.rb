class Dish < ApplicationRecord
  # belongs_to :day_dish
  has_many :dish_ingredients
  has_many :ingredients, through: :dish_ingredients
  validates :name, presence: true
  validates :course, presence: true, uniqueness: true
end
