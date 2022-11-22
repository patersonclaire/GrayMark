class Menu < ApplicationRecord
  belongs_to :school_menu
  belongs_to :profile
  validates :menu_date, presence: true
end
