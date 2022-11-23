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
pasta = Ingredient.create!(name: 'pasta')
cream = Ingredient.create!(name: 'cream')

grace = User.create!(first_name: 'Grace', last_name: 'Allmark', email: 'ga@gmail.com', password: '123123')
portway = School.create!(name: 'Portway', town: 'Andover', postcode: 'SP1 1AA', menu_count: 1, user: grace)
profile_a = Profile.create!(school: portway)
portway_menu = SchoolMenu.create!(date: (Date.today + 1.week).beginning_of_week, school: portway)
menu_a = Menu.create!(profile: profile_a, school_menu: portway_menu, menu_date: portway_menu.date)
carbonara = Dish.create!(name: 'carbonara')
day_dish = DayDish.create!(menu: menu_a, dish: carbonara)
carbonara_pasta = DishIngredient.create!(ingredient: pasta, dish: carbonara)
carbonara_cream = DishIngredient.create!(ingredient: cream, dish: carbonara)
profile_allergy_a = ProfileAllergy.create!(profile: profile_a, ingredient: pasta)
profile_allergy_b = ProfileAllergy.create!(profile: profile_a, ingredient: cream)
