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

ActiveRecord::Schema.define(version: 20170810023811) do

  create_table "compression_springs", force: :cascade do |t|
    t.string   "product_name"
    t.string   "product_number"
    t.float    "min_force"
    t.float    "max_force"
    t.float    "od_length"
    t.float    "cd_length"
    t.float    "inside_diameter"
    t.float    "wire_diameter"
    t.float    "active_coil_num"
    t.float    "total_num"
    t.float    "free_length"
    t.float    "od_force"
    t.float    "cd_force"
    t.integer  "max_tensile_strength", default: 2100,  null: false
    t.integer  "s_elastic_modulus",    default: 78800, null: false
    t.string   "flocking"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["product_number"], name: "index_compression_springs_on_product_number"
  end

  create_table "manual_calculations", force: :cascade do |t|
    t.string   "product_name"
    t.string   "product_number"
    t.float    "hinge_x"
    t.float    "hinge_y"
    t.float    "hinge_z"
    t.float    "centre_gravity_x"
    t.float    "centre_gravity_y"
    t.float    "centre_gravity_z"
    t.float    "door_weight"
    t.float    "body_a_x"
    t.float    "body_a_y"
    t.float    "body_a_z"
    t.float    "gate_b_x"
    t.float    "gate_b_y"
    t.float    "gate_b_z"
    t.float    "open_handle_x"
    t.float    "open_handle_y"
    t.float    "open_handle_z"
    t.float    "close_handle_x"
    t.float    "close_handle_y"
    t.float    "close_handle_z"
    t.float    "open_angle"
    t.float    "open_time"
    t.float    "close_time"
    t.integer  "open_dynamic_friction"
    t.integer  "close_dynamic_friction"
    t.integer  "open_static_friction"
    t.integer  "close_static_friction"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["product_name"], name: "index_manual_calculations_on_product_name"
    t.index ["product_number"], name: "index_manual_calculations_on_product_number"
  end

  create_table "platforms", force: :cascade do |t|
    t.string   "platform_name"
    t.string   "platform_number"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "screw_name"
    t.integer  "number"
    t.float    "pitch"
    t.float    "major_diameter"
    t.float    "pitch_diameter"
    t.float    "lead"
    t.float    "thread_angle"
    t.float    "coefficient_friction"
    t.string   "gearbox_type"
    t.float    "gear_transmission_ratio"
    t.float    "gear_transmission_efficiency"
    t.string   "motor_type"
    t.float    "min_operating_voltage"
    t.float    "rated_voltage"
    t.float    "rated_current"
    t.integer  "rated_speed"
    t.float    "motor_efficiency"
    t.float    "spring_static_length"
    t.float    "inside_diameter"
    t.integer  "max_tensile_strength",         default: 2100,  null: false
    t.integer  "s_elastic_modulus",            default: 78800, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
