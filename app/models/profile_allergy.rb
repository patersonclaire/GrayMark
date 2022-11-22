class ProfileAllergy < ApplicationRecord
  belongs_to :profile
  belongs_to :ingredient
  validates :profile, uniqueness: { scope: :ingredient }
end
