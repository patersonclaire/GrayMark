require "json"
require "open-uri"

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
        @menu.save

        @school_menu.dishes.each do |dish|
          if dish.ingredient_ids.any? { |id| allergens.include?(id) }
            # find a substitute recipe -> search_recipes(...)
          else
            DayDish.create(menu: @menu, dish: dish)
          end
        end
      end
    end
  end

  private

  def search_recipes(diet, intolerances, excludeIngredients, mealtype)

    #diet is selected one by one hard seeded
    #intolerances is selected one by one hard seeded
    #excludeIngredients is selected one by one hard seeded
    #Repeat this for each meal type (main, side, dessert)

    url = "https://api.spoonacular.com/recipes/complexSearch?apiKey=#{ENV['SPOONACULAR_API']}&diet=#{diet}&intolerances=#{intolerances}&excludeIngredients=#{excludeIngredients}&mealtype#{mealtype}"
    dish_serialized = URI.open(url).read
    dishes = JSON.parse(dish_serialized)
    dish = dishes["results"].first["title"]

    # dishes.results.each do |dish|
    # dish.title
    # end
    # https://api.spoonacular.com/recipes/complexSearch?apiKey=99c01005a66940b5a1c9b6e6cfed1ef7&excludeIngredients=eggs,bread,brown rice&diet=vegetarian
  end

  search_recipes("vegetarian", "Seafood", "", "main course")
end
