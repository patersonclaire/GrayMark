class MenusController < ApplicationController
  def new
    @menu = Menu.new
    @school_menu = SchoolMenu.find(params[:school_menu_id])
  end

  def create
    @school_menu = SchoolMenu.find(params[:school_menu_id])
    allergens = params[:menu][:allergen].map { |id| id.to_i }
    # it does not exist
    profile = Profile
              .joins(:profile_allergies)
              .where(profile_allergies: { ingredient_id: allergens })
              .group('profiles.id')
              .having('count(profiles.id) >= ?', allergens.size)

    if !profile.empty?
      p 'Point to exustug one'
    else
      profile = Profile.new(school: @school_menu.school)
      profile.save
      (@school_menu.date..(@school_menu.date + 4.days)).each do |date|

        @menu = Menu.new
        @menu.school_menu = @school_menu
        @menu.profile = profile
        @menu.menu_date = date
        @menu.save

        @school_menu.dishes do |dish|
          raise
          unless dish.ingredient_ids.any? { |id| allergens.include?(id) }
            DayDish.create(menu: @menu, dish: dish)
          end
        end
      end
    end
  end
end
