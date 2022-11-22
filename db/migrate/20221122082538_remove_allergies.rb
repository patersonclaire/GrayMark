class RemoveAllergies < ActiveRecord::Migration[7.0]
  def change
    remove_reference :profile_allergies, :allergy, index: true, foreign_key: true
    drop_table :allergies
    add_reference :profile_allergies, :ingredient, index: true, foreign_key: true, null: false
  end
end
