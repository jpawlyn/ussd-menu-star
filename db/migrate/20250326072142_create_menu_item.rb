class CreateMenuItem < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :title, null: false
      t.string :content
      t.references :account, foreign_key: true
      t.references :menu_item, foreign_key: true, null: true
      t.timestamps
    end
  end
end
