class CreateUserInput < ActiveRecord::Migration[8.0]
  def change
    create_table :user_inputs do |t|
      t.string :key, null: false
      t.string :content
      t.integer :data_type
      t.integer :min_length
      t.integer :max_length
      t.integer :position
      t.references :menu_item, foreign_key: true, null: false
      t.timestamps
    end
    add_index :user_inputs, [ :key, :menu_item_id ], unique: true
  end
end
