# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130520102825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "base58"
    t.string   "name"
    t.decimal  "balance",                  precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "button_code"
    t.string   "order_id"
    t.boolean  "paid",                                              default: false
    t.integer  "download_code"
    t.datetime "download_code_expires_at"
    t.string   "session_secret"
  end

  create_table "passbook_registrations", force: :cascade do |t|
    t.string   "uuid"
    t.string   "device_id"
    t.string   "push_token"
    t.string   "serial_number"
    t.string   "pass_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "registered_with_urban_airship", default: false
  end

  create_table "passes", force: :cascade do |t|
    t.integer  "address_id"
    t.string   "serial_number"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "passes", ["address_id"], name: "index_passes_on_address_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer  "address_id"
    t.decimal  "amount",       precision: 16, scale: 8
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bitcoin_hash"
  end

  add_index "transactions", ["address_id"], name: "index_transactions_on_address_id", using: :btree

end
