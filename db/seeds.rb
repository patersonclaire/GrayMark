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

dietitian = User.create!(first_name: 'Grace', last_name: 'Allmark', email: 'ga@gmail.com', password: '123123')
portway = School.create!(name: 'Portway', town: 'Andover', postcode: 'SP1 1AA', menu_count: 10, user: dietitian)
grinnell = School.create!(name: 'Grinnell', town: 'Iowa', postcode: 'IA5 0LL', menu_count: 10, user: dietitian)
hogwarts = School.create!(name: 'Hogwarts', town: 'Hogsmeade', postcode: 'CH16 1DE', menu_count: 10, user: dietitian)
bsb = School.create!(name: 'BSB', town: 'Bournemouth', postcode: 'BH8 9PY', menu_count: 10, user: dietitian)
st_trinians = School.create!(name: 'St Trainians', town: 'Remenham', postcode: 'RG9 3DD', menu_count: 14, user: dietitian)
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
  portway_school_menu = SchoolMenu.create!(school: portway, date: menu['dates'][0])
  Profile.limit(10).each do |profile|
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

  grinnell_school_menu = SchoolMenu.create!(school: grinnell, date: menu['dates'][0])
  Profile.offset(10).limit(10).each do |profile|
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

  hogwarts_school_menu = SchoolMenu.create!(school: hogwarts, date: menu['dates'][0])
  Profile.offset(20).limit(10).each do |profile|
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

  bsb_school_menu = SchoolMenu.create!(school: bsb, date: menu['dates'][0])
  Profile.offset(30).limit(10).each do |profile|
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

  st_trinians_school_menu = SchoolMenu.create!(school: st_trinians, date: menu['dates'][0])
  Profile.offset(40).each do |profile|
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
