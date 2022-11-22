class Allergy < ApplicationRecord
  validates :allergy_name, presence: true
end
