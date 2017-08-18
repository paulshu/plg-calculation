class CreateManualCalculations < ActiveRecord::Migration[5.0]
  def change
    create_table :manual_calculations do |t|
      t.string :product_name, :index => true
      t.string :product_number, :index => true
      t.float :hinge_x
      t.float :hinge_y
      t.float :hinge_z
      t.float :centre_gravity_x
      t.float :centre_gravity_y
      t.float :centre_gravity_z
      t.float :door_weight     # 门重
      t.float :body_a_x
      t.float :body_a_y
      t.float :body_a_z
      t.float :gate_b_x
      t.float :gate_b_y
      t.float :gate_b_z
      t.float :open_handle_x
      t.float :open_handle_y
      t.float :open_handle_z
      t.float :close_handle_x  # 手动关门作用点H2
      t.float :close_handle_y
      t.float :close_handle_z
      t.float :open_angle
      t.float :open_time
      t.float :close_time
      t.integer :open_dynamic_friction, default: 250, null: false # 开门阻力（动摩擦力）
      t.integer :close_dynamic_friction, default: -270, null: false
      t.integer :open_static_friction, default: 300, null: false  # 开门阻力（静摩擦力）
      t.integer :close_static_friction, default: -320, null: false
      t.timestamps
    end
  end
end
