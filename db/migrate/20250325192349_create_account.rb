class CreateAccount < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.references :service_code, foreign_key: true
      t.timestamps
    end
  end
end
