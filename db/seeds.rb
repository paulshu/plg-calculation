# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Initialize Admin User
if User.find_by(email: "shu@163.com").nil?
  u = User.new
  u.email = "shu@163.com"           # 可以改成自己的 email
  # u.name = "管理员"
  u.password = "123456"                # 最少要六码
  u.password_confirmation = "123456"   # 最少要六码
  u.role = 'admin'
  u.save
  puts "Admin 已经建立好了，帐号为#{u.email}, 密码为#{u.password}"
else
  puts "Admin 已经建立过了，脚本跳过该步骤。"
end


# platform
  Platform.create!(
    id: 1,
    platform_name: "SUV撑杆B17平台",
    platform_number: "B17",
    :screw_name => "5头螺杆",
    :number => 5,
    :pitch => 2.5,
    :major_diameter => 10.0,
    :pitch_diameter => 8.75,
    :lead => 12.5,
    :thread_angle => 40.0,
    :coefficient_friction => 0.14,
    :gearbox_type => "德昌GB22A",
    :gear_transmission_ratio => 22.2,
    :gear_transmission_efficiency => 0.72,
    :motor_type => "德昌DM2916A",
    :min_operating_voltage => 9.0,
    :rated_voltage => 12.0,
    :rated_current => 5.4,
    :rated_speed => 7500,
    :motor_efficiency => 0.6,
    :spring_static_length => 224.1,
    :inside_diameter => 21.55,
    :max_tensile_strength => 2100,
    :s_elastic_modulus => 78800
  )

puts "B17平台导入完成"


# Initialize compression_spring
CompressionSpring.create!(
  :id => 1,
  :product_name => "众泰A45",
  :product_number => "A45",
  :min_force => 624.5,
  :max_force => 1013.0,
  :od_length => 387.23,
  :cd_length => 225.0,
  :inside_diameter => 21.55,
  :wire_diameter => 3.8,
  :active_coil_num => 48.0,
  :total_num => 50.0,
  :free_length => 610.5,
  :od_force => 586.443,
  :cd_force => 1012.558,
  :max_tensile_strength => 2100,
  :s_elastic_modulus => 78800,
  :flocking => "0.4"
)

# Initialize ManualCalculation

ManualCalculation.create!(
  :id => 1,
  :product_name => "众泰A45项目",
  :product_number => "A45",
  :hinge_x => 3470.5,
  :hinge_y => 0.0,
  :hinge_z => 1240.0,
  :centre_gravity_x => 3850.0,
  :centre_gravity_y => 0.0,
  :centre_gravity_z => 853.576,
  :door_weight => 32.31,
  :body_a_x => 3475.0,
  :body_a_y => -585.25,
  :body_a_z => 1120.0,
  :gate_b_x => 3711.0,
  :gate_b_y => -659.67,
  :gate_b_z => 745.25,
  :open_handle_x => 3847.588,
  :open_handle_y => -3.023,
  :open_handle_z => 265.276,
  :close_handle_x => 3847.588,
  :close_handle_y => -3.023,
  :close_handle_z => 265.276,
  :open_angle => 89.0,
  :open_time => 6.0,
  :close_time => 6.0,
  :open_dynamic_friction => 250,
  :close_dynamic_friction => -270,
  :open_static_friction => 300,
  :close_static_friction => -320,
  :platform_id => 1,
  :wire_diameter => 3.8,
  :active_coil_num => 48.0,
  :free_length => 610.5,
  :flocking => "0.4",
  :climbing_degree => 0.2
)
puts "A45车型手工计算数据导入完成"
# Photo.create!(product_id:1, image: MiniMagick::Image.open("#{Rails.root}/app/assets/images/products/product1/101.jpg"))
# Photo.create!(product_id:1, image: MiniMagick::Image.open("#{Rails.root}/app/assets/images/products/product1/102.jpg"))
