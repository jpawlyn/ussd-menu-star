class AddPositionToMenuItem < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :position, :integer
  end
end
