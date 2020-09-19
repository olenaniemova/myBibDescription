# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_19_194909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bibliographic_description_items", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.bigint "source_style_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "publishing_house"
    t.string "subtitle"
    t.integer "number_of_publication"
    t.string "place"
    t.string "ed"
    t.string "url"
    t.index ["source_style_id"], name: "index_bibliographic_description_items_on_source_style_id"
  end

  create_table "bibliographic_descriptions", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_bibliographic_descriptions_on_profile_id"
  end

  create_table "bibliographic_styles", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "profile_id"
    t.index ["profile_id"], name: "index_bibliographic_styles_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "source_styles", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "schema"
    t.bigint "source_id", null: false
    t.bigint "bibliographic_style_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bibliographic_style_id"], name: "index_source_styles_on_bibliographic_style_id"
    t.index ["source_id"], name: "index_source_styles_on_source_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "confirmation_token"
    t.boolean "is_admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "bibliographic_description_items", "source_styles"
  add_foreign_key "bibliographic_descriptions", "profiles"
  add_foreign_key "bibliographic_styles", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "source_styles", "bibliographic_styles"
  add_foreign_key "source_styles", "sources"
end
