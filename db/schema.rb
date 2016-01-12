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

ActiveRecord::Schema.define(version: 20151222123755) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",         null: false
    t.integer  "analytics_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "accounts", ["analytics_id"], name: "index_accounts_on_analytics_id", using: :btree

  create_table "all_organizations", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.integer  "p_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_view_key_values", force: :cascade do |t|
    t.integer  "view_id",                         null: false
    t.datetime "date"
    t.string   "category"
    t.string   "key"
    t.integer  "value"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "known",            default: true, null: false
    t.integer  "page_view_count",  default: 0
    t.integer  "user_count",       default: 0
    t.integer  "session_count",    default: 0
    t.integer  "new_user_count",   default: 0
    t.integer  "session_duration", default: 0
  end

  add_index "daily_view_key_values", ["date", "view_id", "category", "key"], name: "by_category_key", using: :btree
  add_index "daily_view_key_values", ["date", "view_id", "category"], name: "index_daily_view_key_values_on_date_and_view_id_and_category", using: :btree
  add_index "daily_view_key_values", ["date", "view_id"], name: "index_daily_view_key_values_on_date_and_view_id", using: :btree
  add_index "daily_view_key_values", ["known"], name: "index_daily_view_key_values_on_known", using: :btree
  add_index "daily_view_key_values", ["view_id", "category", "key"], name: "by_total_category_key", using: :btree

  create_table "daily_view_metrics", force: :cascade do |t|
    t.integer  "view_id",                       null: false
    t.datetime "date",                          null: false
    t.integer  "page_view_count",   default: 0
    t.integer  "user_count",        default: 0
    t.integer  "session_count",     default: 0
    t.integer  "new_user_count",    default: 0
    t.integer  "session_duration",  default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "return_user_count", default: 0, null: false
  end

  add_index "daily_view_metrics", ["date"], name: "index_daily_view_metrics_on_date", using: :btree
  add_index "daily_view_metrics", ["view_id", "date"], name: "index_daily_view_metrics_on_view_id_and_date", using: :btree
  add_index "daily_view_metrics", ["view_id"], name: "index_daily_view_metrics_on_view_id", using: :btree

  create_table "daily_view_page_views", force: :cascade do |t|
    t.integer  "view_id",                   null: false
    t.string   "permalink",                 null: false
    t.datetime "date",                      null: false
    t.integer  "page_views", default: 0,    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "no_root",    default: true, null: false
  end

  add_index "daily_view_page_views", ["no_root"], name: "index_daily_view_page_views_on_no_root", using: :btree
  add_index "daily_view_page_views", ["view_id", "permalink"], name: "index_daily_view_page_views_on_view_id_and_permalink", using: :btree
  add_index "daily_view_page_views", ["view_id"], name: "index_daily_view_page_views_on_view_id", using: :btree

  create_table "dailyviewstories", force: :cascade do |t|
    t.integer  "view_id"
    t.text     "story_id"
    t.datetime "date"
    t.text     "daily_view_id"
    t.integer  "page_views"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.integer  "p_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ip_organizations", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mention_views", force: :cascade do |t|
    t.integer  "mention_id", null: false
    t.integer  "view_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mention_views", ["view_id"], name: "index_mention_views_on_view_id", using: :btree

  create_table "mentions", force: :cascade do |t|
    t.string   "twitter_id",   null: false
    t.datetime "published_at"
    t.text     "body"
    t.string   "user_handle"
    t.string   "user_image"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "user_name"
  end

  add_index "mentions", ["twitter_id"], name: "index_mentions_on_twitter_id", using: :btree

  create_table "new_pipeline_apis", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.integer  "p_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_pipelines", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.integer  "p_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.integer  "p_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "view_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id", using: :btree
  add_index "permissions", ["view_id"], name: "index_permissions_on_view_id", using: :btree

  create_table "pipelines", force: :cascade do |t|
    t.text     "api_id"
    t.text     "name"
    t.text     "url"
    t.text     "ip"
    t.integer  "p_no",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "stories", force: :cascade do |t|
    t.text     "story_id"
    t.text     "organization_id"
    t.integer  "community_id"
    t.date     "published_at"
    t.integer  "type_id"
    t.text     "headline"
    t.text     "author"
    t.boolean  "published"
    t.boolean  "paid"
    t.integer  "p_no"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "admin",                  default: false, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "views", force: :cascade do |t|
    t.string   "twitter_handle"
    t.integer  "analytics_id",   null: false
    t.string   "url",            null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name",           null: false
    t.text     "logo"
    t.string   "widget_id"
    t.integer  "account_id"
  end

  add_index "views", ["analytics_id"], name: "index_views_on_analytics_id", using: :btree
  add_index "views", ["url"], name: "index_views_on_url", using: :btree

  create_table "xls_data", force: :cascade do |t|
    t.text     "ga_url"
    t.text     "pipeline_url"
    t.text     "pipeline_name"
    t.string   "unique_reader"
    t.string   "stories_read"
    t.string   "page_session"
    t.string   "avg_session"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
