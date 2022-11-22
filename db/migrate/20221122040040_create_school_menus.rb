class CreateSchoolMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :school_menus do |t|
      t.date :date
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
