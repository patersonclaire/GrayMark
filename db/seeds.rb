require 'csv'
require 'json'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Cleaning database'
DishIngredient.destroy_all
ProfileAllergy.destroy_all
Ingredient.destroy_all
DayDish.destroy_all
Menu.destroy_all
SchoolMenu.destroy_all
Profile.destroy_all
School.destroy_all
User.destroy_all

puts 'Creating Ingredient List'

grace = User.create!(first_name: 'Grace', last_name: 'Allmark', email: 'ga@gmail.com', password: '123123')
portway = School.create!(name: 'Portway', town: 'Andover', postcode: 'SP1 1AA', menu_count: 1, user: grace)
CSV.foreach('db/data/allergy.csv', headers: true, header_converters: :symbol) do |row|
  ingredient = Ingredient.create!(name: row[:name])
  profile = Profile.create!(school: portway)
  profile_allergy = ProfileAllergy.create!(profile: profile, ingredient: ingredient)
end

filepath = 'db/data/menu.json'
serialized_menu = File.read(filepath)
menus = JSON.parse(serialized_menu)
# pp menu
menus.each do |menu|
  menu = menu['menu']
  school_menu = SchoolMenu.create!(school: portway, date: menu['dates'][0])
  Profile.all.each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: school_menu, menu_date: date)
      # pp menu
      monday_dishes = menu['days'][0]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end

    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i]) + 1.day
      p date
      tailord_menu = Menu.create!(profile: profile, school_menu: school_menu, menu_date: date)
      monday_dishes = menu['days'][1]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end

    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i]) + 2.day
      p date
      tailord_menu = Menu.create!(profile: profile, school_menu: school_menu, menu_date: date)
      monday_dishes = menu['days'][2]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end

    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i]) + 3.day
      p date
      tailord_menu = Menu.create!(profile: profile, school_menu: school_menu, menu_date: date)
      monday_dishes = menu['days'][3]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end

    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i]) + 4.day
      p date
      tailord_menu = Menu.create!(profile: profile, school_menu: school_menu, menu_date: date)
      monday_dishes = menu['days'][4]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end
  end
end


# portway_menu = SchoolMenu.create!(date: (Date.today + 1.week).beginning_of_week, school: portway)
# menu_a = Menu.create!(profile: profile_a, school_menu: portway_menu, menu_date: portway_menu.date)
# carbonara = Dish.create!(name: 'carbonara')
# day_dish = DayDish.create!(menu: menu_a, dish: carbonara)
# carbonara_pasta = DishIngredient.create!(ingredient: pasta, dish: carbonara)
# carbonara_cream = DishIngredient.create!(ingredient: cream, dish: carbonara)
# profile_allergy_b = ProfileAllergy.create!(profile: profile_a, ingredient: cream)
