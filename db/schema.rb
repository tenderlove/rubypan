# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090418052030) do

  create_table "authors", :force => true do |t|
    t.text     "name"
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_ruby_gems", :id => false, :force => true do |t|
    t.integer "author_id"
    t.integer "ruby_gem_id"
  end

  create_table "ratings", :force => true do |t|
    t.integer "rating"
    t.integer "rateable_id",   :null => false
    t.string  "rateable_type", :null => false
  end

  add_index "ratings", ["rateable_id", "rating"], :name => "index_ratings_on_rateable_id_and_rating"

  create_table "releases", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "rubyforge_project"
    t.date     "released_on"
    t.text     "homepage"
    t.text     "summary"
    t.text     "description"
    t.text     "spec"
    t.text     "meta"
    t.boolean  "latest"
    t.integer  "ruby_gem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ruby_gems", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
