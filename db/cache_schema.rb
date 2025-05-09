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

ActiveRecord::Schema[8.0].define(version: 2025_04_22_130042) do
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
    t.boolean "terminate_session", default: false, null: false
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

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "user_data_collections", force: :cascade do |t|
    t.string "msisdn"
    t.jsonb "data"
    t.bigint "menu_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_user_data_collections_on_menu_item_id"
  end

  create_table "user_inputs", force: :cascade do |t|
    t.string "key", null: false
    t.string "content"
    t.integer "data_type"
    t.integer "min_length"
    t.integer "max_length"
    t.integer "position"
    t.bigint "menu_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key", "menu_item_id"], name: "index_user_inputs_on_key_and_menu_item_id", unique: true
    t.index ["menu_item_id"], name: "index_user_inputs_on_menu_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "accounts", "service_codes"
  add_foreign_key "menu_items", "accounts"
  add_foreign_key "menu_items", "menu_items"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_data_collections", "menu_items"
  add_foreign_key "user_inputs", "menu_items"
end
