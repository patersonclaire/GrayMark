class CreateDishIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :dish_ingredients do |t|
      t.references :dish, null: false, foreign_key: true

      t.timestamps
    end
  end
end
