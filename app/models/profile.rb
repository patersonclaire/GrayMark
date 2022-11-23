class Profile < ApplicationRecord
  belongs_to :school
  has_many :profile_allergies
  has_many :ingredients, through: :profile_allergies
end
