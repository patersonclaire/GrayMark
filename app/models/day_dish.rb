class DayDish < ApplicationRecord
  belongs_to :menu
  belongs_to :dish
end
