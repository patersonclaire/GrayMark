require 'csv'
require 'json'
require "open-uri"

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)

puts 'Cleaning database'
DishIngredient.destroy_all
ProfileAllergy.destroy_all
Ingredient.destroy_all
DayDish.destroy_all
Dish.destroy_all
Menu.destroy_all
SchoolMenu.destroy_all
Profile.destroy_all
School.destroy_all
User.destroy_all

puts 'Creating Ingredient List'

dietitian = User.create!(first_name: 'Grace', last_name: 'Allmark', email: 'ga@gmail.com', password: '123123')

cheam = School.create!(name: 'Cheam', town: 'Newbury', postcode: 'RG19 8LD', menu_count: 10, user: dietitian)
file = URI.open('https://res.cloudinary.com/df5d4fbx4/image/upload/v1669285015/vmesyzufqtwdcrqopv2l.jpg')
cheam.photo.attach(io: file, filename: 'cheam.jpg', content_type: 'image/jpg')
cheam.save

eton = School.create!(name: 'Eton', town: 'Windsor', postcode: 'SL4 6DW', menu_count: 10, user: dietitian)
file = URI.open('https://res.cloudinary.com/df5d4fbx4/image/upload/v1669285266/ug7wnbkxu1borfrnv4w8.jpg')
eton.photo.attach(io: file, filename: 'eton.jpg', content_type: 'image/jpg')
eton.save

hogwarts = School.create!(name: 'Hogwarts', town: 'Hogsmeade', postcode: 'CH16 1DE', menu_count: 10, user: dietitian)
file = URI.open('https://res.cloudinary.com/df5d4fbx4/image/upload/v1669283546/mbehaazckdwyrz7txvtj.jpg')
hogwarts.photo.attach(io: file, filename: 'hogwarts.jpg', content_type: 'image/jpg')
hogwarts.save

bsb = School.create!(name: 'BSB', town: 'Bournemouth', postcode: 'BH8 9PY', menu_count: 10, user: dietitian)
file = URI.open('https://res.cloudinary.com/df5d4fbx4/image/upload/v1669285048/uw5wxfx7jgimvkm8i1lz.jpg')
bsb.photo.attach(io: file, filename: 'bsb.jpg', content_type: 'image/jpg')
bsb.save

st_trinians = School.create!(name: 'St Trinians', town: 'Remenham', postcode: 'RG9 3DD', menu_count: 14, user: dietitian)
file = URI.open('https://res.cloudinary.com/df5d4fbx4/image/upload/v1669285062/lej4phekj0rlueypqpsv.jpg')
st_trinians.photo.attach(io: file, filename: 'st_trinians.jpg', content_type: 'image/jpg')
st_trinians.save

kings = School.create!(name: 'Kings', town: 'Winchester', postcode: 'SO22 5PN', menu_count: 4, user: dietitian)
file = URI.open('https://res.cloudinary.com/df5d4fbx4/image/upload/v1669726023/rfqojlnjwiyttmu5qv0a.png')
kings.photo.attach(io: file, filename: 'kings.jpg', content_type: 'image/jpg')
kings.save

CSV.foreach('db/data/allergy.csv', headers: true, header_converters: :symbol) do |row|
  ingredient = Ingredient.find_or_create_by(name: row[:name])
  profile = Profile.create!(school: cheam)
  profile_allergy = ProfileAllergy.create!(profile: profile, ingredient: ingredient)
end

dessert_keywords = ['fruit', 'ice cream', 'yoghurt', 'pudding', 'custard', 'angel']
CSV.foreach('db/data/Ingredients_Allergens.csv', headers: true, header_converters: :symbol, col_sep: ';') do |row|
  name = row[:recipe]
  allergens = row[:allergens]
  course = dessert_keywords.include?(name) ? 'dessert' : 'main'
  dish = Dish.create!(name: name, course: course)
  # url = "https://api.spoonacular.com/recipes/complexSearch?apiKey=#{ENV['SPOONACULAR_API']}&query=#{name}"
  # response = URI.open(url).read
  # data = JSON.parse(response)
  if allergens != nil
    allergies = allergens.gsub('Cereals containing', '').split(',')
    allergies.each do |allergy|
      ingredient_name = allergy.strip
      ingredient = Ingredient.find_or_create_by(name: ingredient_name)
      dish_ingredient = DishIngredient.create!(ingredient: ingredient, dish: dish)
    end
  end
end

filepath = 'db/data/menu.json'
serialized_menu = File.read(filepath)
menus = JSON.parse(serialized_menu)
menus.each do |menu|
  menu = menu['menu']
  cheam_school_menu = SchoolMenu.create!(school: cheam, date: Date.parse(menu['dates'][0]))
  Profile.limit(5).each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: cheam_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: cheam_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: cheam_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: cheam_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: cheam_school_menu, menu_date: date)
      monday_dishes = menu['days'][4]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end
  end

  eton_school_menu = SchoolMenu.create!(school: eton, date: Date.parse(menu['dates'][0]))
  Profile.offset(5).limit(5).each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: eton_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: eton_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: eton_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: eton_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: eton_school_menu, menu_date: date)
      monday_dishes = menu['days'][4]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end
  end

  hogwarts_school_menu = SchoolMenu.create!(school: hogwarts, date: Date.parse(menu['dates'][0]))
  Profile.offset(10).limit(5).each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: hogwarts_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: hogwarts_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: hogwarts_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: hogwarts_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: hogwarts_school_menu, menu_date: date)
      monday_dishes = menu['days'][4]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end
  end

  bsb_school_menu = SchoolMenu.create!(school: bsb, date: Date.parse(menu['dates'][0]))
  Profile.offset(15).limit(5).each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: bsb_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: bsb_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: bsb_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: bsb_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: bsb_school_menu, menu_date: date)
      monday_dishes = menu['days'][4]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end
  end

  st_trinians_school_menu = SchoolMenu.create!(school: st_trinians, date: Date.parse(menu['dates'][0]))
  Profile.offset(20).limit(5).each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: st_trinians_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: st_trinians_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: st_trinians_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: st_trinians_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: st_trinians_school_menu, menu_date: date)
      monday_dishes = menu['days'][4]
      main_one = Dish.create!(name: monday_dishes['main_one'], course: 'main')
      main_two = Dish.create!(name: monday_dishes['main_two'], course: 'main')
      dessert = Dish.create!(name: monday_dishes['dessert'], course: 'dessert')
      DayDish.create!(menu: tailord_menu, dish: main_one)
      DayDish.create!(menu: tailord_menu, dish: main_two)
      DayDish.create!(menu: tailord_menu, dish: dessert)
    end
  end

  kings_school_menu = SchoolMenu.create!(school: kings, date: Date.parse(menu['dates'][0]))
  Profile.offset(25).each do |profile|
    menu['dates'].size.times do |i|
      date = Date.parse(menu['dates'][i])
      tailord_menu = Menu.create!(profile: profile, school_menu: kings_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: kings_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: kings_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: kings_school_menu, menu_date: date)
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
      tailord_menu = Menu.create!(profile: profile, school_menu: kings_school_menu, menu_date: date)
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

CSV.foreach(filepath, headers: :first_row) do |row|
  # puts "#{row['First Name']} #{row['Last Name']} played #{row['Instrument']}"
  p row
  Ingredient.create!(name: row[0].split(";")[0])
end

pp Ingredient.all

