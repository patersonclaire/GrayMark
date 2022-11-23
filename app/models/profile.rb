class Profile < ApplicationRecord
  belongs_to :school
  has_many :profile_alleries
  has_many :ingredients, through: :profile_alleriess
end
