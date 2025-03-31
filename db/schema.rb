# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_31_115720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "service_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_code_id"], name: "index_accounts_on_service_code_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "title", null: false
    t.string "content"
    t.bigint "account_id"
    t.bigint "menu_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["account_id"], name: "index_menu_items_on_account_id"
    t.index ["menu_item_id"], name: "index_menu_items_on_menu_item_id"
  end

  create_table "service_codes", force: :cascade do |t|
    t.string "name", null: false
    t.string "country_code", null: false
    t.string "number"
    t.string "short_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_code"], name: "index_service_codes_on_country_code"
    t.index ["name"], name: "index_service_codes_on_name", unique: true
    t.index ["short_name", "country_code"], name: "index_service_codes_on_short_name_and_country_code", unique: true
  end

  add_foreign_key "accounts", "service_codes"
  add_foreign_key "menu_items", "accounts"
  add_foreign_key "menu_items", "menu_items"
end
