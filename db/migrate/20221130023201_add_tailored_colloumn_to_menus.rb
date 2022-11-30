class AddTailoredColloumnToMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :tailored, :boolean, default: false
  end
end
