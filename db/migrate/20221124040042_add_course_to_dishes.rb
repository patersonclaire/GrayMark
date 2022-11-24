class AddCourseToDishes < ActiveRecord::Migration[7.0]
  def change
    add_column :dishes, :course, :string
  end
end
