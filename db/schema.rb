# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_20_064243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_orders", force: :cascade do |t|
    t.bigint "food_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id", "order_id"], name: "food_order", unique: true
    t.index ["food_id"], name: "index_food_orders_on_food_id"
    t.index ["order_id"], name: "index_food_orders_on_order_id"
  end

  create_table "foods", force: :cascade do |t|
    t.bigint "menu_id"
    t.integer "number"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_foods_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "menu_id"
    t.string "chatwork_id"
    t.string "message_id"
    t.string "note"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_orders_on_menu_id"
  end

end
