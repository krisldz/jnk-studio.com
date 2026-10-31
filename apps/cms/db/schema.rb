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

ActiveRecord::Schema[8.1].define(version: 2026_10_31_180000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.jsonb "slug", default: {}, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_categories_on_position"
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "place"
    t.string "inquiry_type"
    t.text "message"
    t.boolean "consent", default: false, null: false
    t.string "locale", default: "pl", null: false
    t.string "status", default: "new", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_inquiries_on_created_at"
    t.index ["status"], name: "index_inquiries_on_status"
  end

  create_table "post_categories", force: :cascade do |t|
    t.jsonb "name", default: {}, null: false
    t.jsonb "slug", default: {}, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_post_categories_on_position"
  end

  create_table "posts", force: :cascade do |t|
    t.jsonb "slug", default: {}, null: false
    t.jsonb "title", default: {}, null: false
    t.jsonb "lead", default: {}, null: false
    t.jsonb "body", default: {}, null: false
    t.string "author"
    t.integer "reading_time"
    t.bigint "post_category_id"
    t.boolean "featured", default: false, null: false
    t.integer "position", default: 0, null: false
    t.string "status", default: "draft", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featured"], name: "index_posts_on_featured"
    t.index ["position"], name: "index_posts_on_position"
    t.index ["post_category_id"], name: "index_posts_on_post_category_id"
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug", using: :gin
    t.index ["status"], name: "index_posts_on_status"
  end

  create_table "project_images", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.jsonb "alt", default: {}, null: false
    t.string "credit"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "position"], name: "index_project_images_on_project_id_and_position"
    t.index ["project_id"], name: "index_project_images_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.jsonb "slug", default: {}, null: false
    t.jsonb "title", default: {}, null: false
    t.jsonb "lead", default: {}, null: false
    t.jsonb "body", default: {}, null: false
    t.integer "year"
    t.string "location"
    t.integer "area_m2"
    t.bigint "category_id"
    t.boolean "featured", default: false, null: false
    t.integer "position", default: 0, null: false
    t.string "status", default: "draft", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_projects_on_category_id"
    t.index ["featured"], name: "index_projects_on_featured"
    t.index ["position"], name: "index_projects_on_position"
    t.index ["slug"], name: "index_projects_on_slug", using: :gin
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "posts", "post_categories"
  add_foreign_key "project_images", "projects"
  add_foreign_key "projects", "categories"
  add_foreign_key "sessions", "users"
end
