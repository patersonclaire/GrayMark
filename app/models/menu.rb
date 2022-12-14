class Menu < ApplicationRecord
  belongs_to :school_menu
  belongs_to :profile
  has_many :day_dishes
  has_many :dishes, through: :day_dishes
  validates :menu_date, presence: true, uniqueness: { scope: %i[school_menu profile] }
  attribute :diet, :string
  attribute :intolerances, :string
end
