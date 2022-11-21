class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :town
      t.string :postcode
      t.integer :menu_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
