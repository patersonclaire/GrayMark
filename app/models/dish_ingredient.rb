class DishIngredient < ApplicationRecord
  belongs_to :dish
  has_many :ingredients
end
