require "json"
require "open-uri"

class MenusController < ApplicationController

  def show
    @menu = Menu.find(params[:id])
    @menus_in_week = @menu.school_menu.menus.where(menu_date: (@menu.menu_date)..(@menu.menu_date + 4.days), tailored: @menu.tailored, profile: @menu.profile)
  end

  def new
    @menu = Menu.new
    @school_menu = SchoolMenu.find(params[:school_menu_id])
  end

  def create
    # Grab the (WEEKLY) School Menu to be created off of
    @school_menu = SchoolMenu.find(params[:school_menu_id])
    # Grab chosen allergens from the Form
    # raise
    diet = params[:menu][:diet]
    intolerances = params[:menu][:intolerances].reject { |i| i.blank? }
    allergens = params[:menu][:ingredient].values.reject { |id| id.blank? }.map { |id| id.to_i }.reject { |id| id == 0 }
    # Find existing allergen combination

    profile = @school_menu
    .profiles
    .joins(:profile_allergies)
    .where(profile_allergies: { ingredient_id: allergens })
    .group('profiles.id')
    .having('count(profiles.id) >= ?', allergens.size)

    if !profile.empty?
      # redirect to existing menu
      redirect_to school_path(profile.school)
    else
      # This `else` clause happens when there isn't an existing allergy combination
      # Creates a fresh new Profile (because its a new combination)
      profile = Profile.new(school: @school_menu.school)
      profile.save

      # Connects the new Profile to the chosen allergens
      allergens.each do |ingredient_id|
        new_profile_allergy = ProfileAllergy.new
        new_profile_allergy.profile = profile
        new_profile_allergy.ingredient_id = ingredient_id
        new_profile_allergy.save
      end

      # For the following week, create the new menu/dishes for this new Profile
      # Q: Should it be the following week or the following period (3 weeks/18 days?) 🕵️‍♂️
      (@school_menu.date..(@school_menu.date + 4.days)).each do |date|
        @menu = Menu.new
        @menu.school_menu = @school_menu
        @menu.profile = profile
        @menu.menu_date = date
        @menu.tailored = true
        @menu.save


        # TODO: Fix hardcoding to grab from form 🥸
        main = Spoonacular.new(diet, intolerances.join(","), allergens, "main course")
        dish = main.call
        DayDish.create(menu: @menu, dish: dish)

        side = Spoonacular.new(diet, intolerances.join(","), allergens, "side dish")
        dish = side.call
        DayDish.create(menu: @menu, dish: dish)

        dessert = Spoonacular.new(diet, intolerances.join(","), allergens, "dessert")
        dish = dessert.call
        DayDish.create(menu: @menu, dish: dish)
      end

      redirect_to menu_path(@school_menu.menus.first)
    end
  end
end

# @existing_menu.dishes.each do |dish|
#   unless dish.ingredient_ids.any? { |id| allergens.include?(id) }
#     DayDish.create(menu: @menu, dish: dish)
#   end
# end
