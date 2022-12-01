class SchoolMenu < ApplicationRecord
  belongs_to :school
  has_many :menus
  has_many :profiles, through: :menus
  has_many :day_dishes, through: :menus
  has_many :dishes, through: :day_dishes
  validates :date, presence: true
end
