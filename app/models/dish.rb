class Dish < ApplicationRecord
  # belongs_to :day_dish
  has_many :dish_ingredients
  has_many :ingredients, through: :dish_ingredients
  validates :name, presence: true
  validates :course, presence: true
  has_one_attached :image
end
