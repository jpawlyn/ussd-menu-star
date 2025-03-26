class CreateServiceCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :service_codes do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :country_code, null: false, index: true
      t.string :number
      t.string :short_name, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
