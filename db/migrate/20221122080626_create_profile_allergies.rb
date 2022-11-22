class CreateProfileAllergies < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_allergies do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :allergy, null: false, foreign_key: true

      t.timestamps
    end
  end
end
