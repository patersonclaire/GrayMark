class School < ApplicationRecord
  belongs_to :user
  has_many :school_menus
  validates :postcode, presence: true, uniqueness: true
  validates :name, presence: true, inclusion: { in: :town }
  validates :town, presence: true, inclusion: { in: :name }
end
