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

ActiveRecord::Schema.define(version: 20160823203313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auctions", force: :cascade do |t|
    t.integer  "item_id",      null: false
    t.integer  "character_id", null: false
    t.integer  "realm_id",     null: false
    t.bigint   "bid",          null: false
    t.bigint   "buyout",       null: false
    t.integer  "quantity",     null: false
    t.string   "time_left",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_auctions_on_character_id", using: :btree
    t.index ["item_id"], name: "index_auctions_on_item_id", using: :btree
    t.index ["realm_id"], name: "index_auctions_on_realm_id", using: :btree
  end

  create_table "characters", force: :cascade do |t|
    t.integer  "guild_id"
    t.integer  "clazz_id"
    t.integer  "race_id"
    t.integer  "realm_id",           null: false
    t.string   "name",               null: false
    t.integer  "gender"
    t.integer  "level"
    t.integer  "achievement_points"
    t.integer  "faction"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["clazz_id"], name: "index_characters_on_clazz_id", using: :btree
    t.index ["guild_id"], name: "index_characters_on_guild_id", using: :btree
    t.index ["race_id"], name: "index_characters_on_race_id", using: :btree
    t.index ["realm_id", "name"], name: "index_characters_on_realm_id_and_name", unique: true, using: :btree
    t.index ["realm_id"], name: "index_characters_on_realm_id", using: :btree
  end

  create_table "clazzs", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "power_type", null: false
    t.integer  "mask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guilds", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "realm_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["realm_id"], name: "index_guilds_on_realm_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "item_bind",      null: false
    t.integer  "item_level",     null: false
    t.integer  "item_clazz"
    t.integer  "item_sub_clazz"
    t.integer  "buy_price"
    t.integer  "sell_price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "races", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "side",       null: false
    t.integer  "mask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "realms", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "slug",        null: false
    t.string   "realm_type",  null: false
    t.string   "population",  null: false
    t.string   "battlegroup", null: false
    t.string   "locale",      null: false
    t.string   "timezone",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
