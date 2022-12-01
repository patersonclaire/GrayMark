class Spoonacular
  def initialize(diet, intolerances, excludeIngredients, mealtype)
    @diet = diet
    @intolerances = intolerances
    @excludeIngredients = excludeIngredients.map { |id| Ingredient.find(id).name }.join(", ")
    @mealtype = mealtype
  end

  def call
    search_recipes
    make_dishes
  end

  private

  def search_recipes
    url = "https://api.spoonacular.com/recipes/complexSearch?apiKey=#{ENV['SPOONACULAR_API']}&diet=#{@diet}&intolerances=#{@intolerances}&excludeIngredients=#{@excludeIngredients}&type=#{@mealtype}"
    dish_serialized = URI.open(url).read
    dishes = JSON.parse(dish_serialized)
    @dish_api_info = dishes["results"].sample
  end

  def make_dishes
    @dish = Dish.find_or_create_by(name: @dish_api_info["title"], course: @mealtype)
    if @dish.previously_new_record?
      attach_images
    end

    make_ingredients
    return @dish
  end

  def attach_images
    # get img url
    file = URI.open(@dish_api_info["image"])
    @dish.image.attach(io: file, filename: "dish.png", content_type: "image/png")
    @dish.save
  end

  def make_ingredients
    id = @dish_api_info["id"]
    url = "https://api.spoonacular.com/recipes/#{id}/information?apiKey=#{ENV['SPOONACULAR_API']}"
    ingredients_serialized = URI.open(url).read
    ingredients_raw = JSON.parse(ingredients_serialized)

    ingredients = ingredients_raw["extendedIngredients"]

    ingredients.each do |ingredient_info|
      name = ingredient_info["nameClean"]
      ingredient = Ingredient.find_or_create_by(name: name)
      DishIngredient.new(ingredient: ingredient, dish: @dish)
    end
  end
end

#diet is selected one by one hard seeded
#intolerances is selected one by one hard seeded
#excludeIngredients is selected one by one hard seeded
#Repeat this for each meal type (main, side, dessert)
