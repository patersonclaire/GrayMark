class MenusController < ApplicationController
  def new
    @menu = Menu.new
    @school_menu = SchoolMenu.find(params[:school_menu_id])
  end

  def create
    @school_menu = SchoolMenu.find(params[:school_menu_id])
    allergens = params[:menu].values.reject { |id| id.blank? }.map { |id| id.to_i }
    # it does not exist
    profile = Profile
              .joins(:profile_allergies)
              .where(profile_allergies: { ingredient_id: allergens })
              .group('profiles.id')
              .having('count(profiles.id) >= ?', allergens.size)

    if !profile.empty?
      p 'Point to existing one'
      # redirect to existing menu
    else
      profile = Profile.new(school: @school_menu.school)
      profile.save

      allergens.each do |ingredient_id|
        new_profile_allergy = ProfileAllergy.new
        new_profile_allergy.profile = profile
        new_profile_allergy.ingredient_id = ingredient_id
        new_profile_allergy.save
      end

      (@school_menu.date..(@school_menu.date + 4.days)).each do |date|

        @menu = Menu.new
        @menu.school_menu = @school_menu
        @menu.profile = profile
        @menu.menu_date = date
        @menu.tailored = true
        @menu.save

        @school_menu.dishes.each do |dish|
          unless dish.ingredient_ids.any? { |id| allergens.include?(id) }
            DayDish.create(menu: @menu, dish: dish)
          end
        end
      end

      redirect_to school_path(@school_menu.school)
    end
  end
end
