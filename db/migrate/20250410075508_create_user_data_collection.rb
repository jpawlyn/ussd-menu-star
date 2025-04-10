class CreateUserDataCollection < ActiveRecord::Migration[8.0]
  def change
    create_table :user_data_collections do |t|
      t.string :msisdn
      t.jsonb :data
      t.references :menu_item, foreign_key: true
      t.timestamps
    end
  end
end
