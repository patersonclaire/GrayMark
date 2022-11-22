class ProfileAllergy < ApplicationRecord
  belongs_to :profile
  belongs_to :allergy
end
