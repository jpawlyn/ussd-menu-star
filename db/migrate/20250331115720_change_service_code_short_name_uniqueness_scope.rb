class ChangeServiceCodeShortNameUniquenessScope < ActiveRecord::Migration[8.0]
  def change
    remove_index :service_codes, :short_name
    add_index :service_codes, [ :short_name, :country_code ], unique: true
  end
end
