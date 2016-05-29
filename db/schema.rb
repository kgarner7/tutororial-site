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

ActiveRecord::Schema.define(version: 20160528185125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.integer  "step_id"
    t.string   "type"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "actions", ["step_id"], name: "index_actions_on_step_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "step_action_id"
    t.string   "answer"
    t.boolean  "correct"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "answer_type"
    t.string   "unique_hash"
    t.integer  "index"
  end

  add_index "answers", ["step_action_id"], name: "index_answers_on_step_action_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string   "file_name"
    t.string   "error"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "read"
    t.string   "previous_code"
    t.string   "encrypted_previous_code"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "file_name"
    t.integer  "student_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "file_type"
    t.string   "previous_code"
    t.string   "encrypted_previous_code"
  end

  add_index "messages", ["student_id"], name: "index_messages_on_student_id", using: :btree

  create_table "step_actions", force: :cascade do |t|
    t.integer  "step_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "value"
    t.string   "action_type"
    t.integer  "index"
    t.integer  "score"
    t.integer  "temp_score"
    t.integer  "temp_index"
  end

  add_index "step_actions", ["step_id"], name: "index_step_actions_on_step_id", using: :btree

  create_table "steps", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "index"
    t.string   "name"
    t.integer  "temp_index"
  end

  add_index "steps", ["lesson_id"], name: "index_steps_on_lesson_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "admin"
  end

  create_table "user_progresses", force: :cascade do |t|
    t.integer  "step_id"
    t.integer  "student_id"
    t.integer  "score"
    t.integer  "lesson_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "unique_hash"
  end

  add_index "user_progresses", ["lesson_id"], name: "index_user_progresses_on_lesson_id", using: :btree
  add_index "user_progresses", ["step_id"], name: "index_user_progresses_on_step_id", using: :btree
  add_index "user_progresses", ["student_id"], name: "index_user_progresses_on_student_id", using: :btree
  add_index "user_progresses", ["unique_hash"], name: "index_user_progresses_on_unique_hash", unique: true, using: :btree

  add_foreign_key "actions", "steps"
  add_foreign_key "answers", "step_actions"
  add_foreign_key "messages", "students"
  add_foreign_key "step_actions", "steps"
  add_foreign_key "steps", "lessons"
  add_foreign_key "user_progresses", "lessons"
  add_foreign_key "user_progresses", "steps"
  add_foreign_key "user_progresses", "students"
end
