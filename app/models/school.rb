class School < ApplicationRecord
  belongs_to :user
  has_many :school_menus
  has_many :menus, through: :school_menus
  has_many :profiles
  has_one_attached :photo
  validates :postcode, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { scope: :town }
  validates :town, presence: true
end
