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

ActiveRecord::Schema.define(version: 2022_11_03_203505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
    t.index ["workshop_id"], name: "index_bookmarks_on_workshop_id"
  end

  create_table "caffeinate_campaign_subscriptions", force: :cascade do |t|
    t.bigint "caffeinate_campaign_id", null: false
    t.string "subscriber_type", null: false
    t.integer "subscriber_id", null: false
    t.string "user_type"
    t.integer "user_id"
    t.string "token", null: false
    t.datetime "ended_at"
    t.string "ended_reason"
    t.datetime "resubscribed_at"
    t.datetime "unsubscribed_at"
    t.string "unsubscribe_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["caffeinate_campaign_id", "subscriber_id", "subscriber_type", "user_id", "user_type", "ended_at", "resubscribed_at", "unsubscribed_at"], name: "index_caffeinate_campaign_subscriptions"
    t.index ["caffeinate_campaign_id"], name: "caffeineate_campaign_subscriptions_on_campaign"
    t.index ["token"], name: "index_caffeinate_campaign_subscriptions_on_token", unique: true
  end

  create_table "caffeinate_campaigns", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_caffeinate_campaigns_on_slug", unique: true
  end

  create_table "caffeinate_mailings", force: :cascade do |t|
    t.bigint "caffeinate_campaign_subscription_id", null: false
    t.datetime "send_at", null: false
    t.datetime "sent_at"
    t.datetime "skipped_at"
    t.string "mailer_class", null: false
    t.string "mailer_action", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["caffeinate_campaign_subscription_id", "send_at", "sent_at", "skipped_at"], name: "index_caffeinate_mailings"
    t.index ["caffeinate_campaign_subscription_id"], name: "index_caffeinate_mailings_on_campaign_subscription"
  end

  create_table "consult_products", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.index ["order_id"], name: "index_consult_products_on_order_id"
  end

  create_table "consultations", force: :cascade do |t|
    t.string "consult_category"
    t.datetime "date_time"
    t.boolean "completed", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "gcal_event_id"
    t.text "notes"
    t.index ["user_id"], name: "index_consultations_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "state"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "recognized", default: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.index ["order_id"], name: "index_products_on_order_id"
    t.index ["workshop_id"], name: "index_products_on_workshop_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.integer "moodle_id"
    t.string "moodle_password"
    t.integer "remaining_consultations", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "fullname"
    t.string "shortname"
    t.text "summary"
    t.string "language"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "moodle_id"
    t.string "category"
    t.integer "price_cents", default: 0, null: false
  end

  add_foreign_key "bookmarks", "users"
  add_foreign_key "bookmarks", "workshops"
  add_foreign_key "caffeinate_campaign_subscriptions", "caffeinate_campaigns"
  add_foreign_key "caffeinate_mailings", "caffeinate_campaign_subscriptions"
  add_foreign_key "consult_products", "orders"
  add_foreign_key "consultations", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "orders"
  add_foreign_key "products", "workshops"
end
