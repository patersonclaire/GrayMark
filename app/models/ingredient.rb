class Ingredient < ApplicationRecord
  validates :name, presence: true
  has_many :dish_ingredient, dependent: :destroy
  has_many :profile_allergy, dependent: :destroy


  def self.diets
    diets = ["Vegetarian", "Vegan", "Pescetarian", "Paleo"]
  end

  def self.intolerances
    intolerances = ["Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
  end
end
