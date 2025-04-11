class AddTerminateSessionToMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_items, :terminate_session, :boolean, default: false, null: false
  end
end
