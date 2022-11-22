class SchoolMenu < ApplicationRecord
  belongs_to :school
  has_many :menus
  validates :date, presence: true
end
