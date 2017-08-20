class ManualCalculation < ApplicationRecord

  attr_accessor :current_step
  validates :product_name, presence:  { message: "请填写产品或项目名称" }, :if => :should_validate_basic_data?
  validates :product_number,  presence:  { message: "请填写产品编号" },
                             uniqueness: { message: "产品编号重复了" }, :if => :should_validate_basic_data?
  validates :hinge_x, presence:  { message: "请填写旋转中心坐标" }, :if => :should_validate_basic_data?
  validates :hinge_y, presence:  { message: "请填写旋转中心坐标" }, :if => :should_validate_basic_data?
  validates :hinge_z, presence:  { message: "请填写旋转中心坐标" }, :if => :should_validate_basic_data?
  validates :centre_gravity_x, presence:  { message: "请填写重心坐标" }, :if => :should_validate_basic_data?
  validates :centre_gravity_y, presence:  { message: "请填写重心坐标" }, :if => :should_validate_basic_data?
  validates :centre_gravity_z, presence:  { message: "请填写重心坐标" }, :if => :should_validate_basic_data?
  validates :open_handle_x, presence:  { message: "请填写手动开门点坐标" }, :if => :should_validate_basic_data?
  validates :open_handle_y, presence:  { message: "请填写手动开门点坐标" }, :if => :should_validate_basic_data?
  validates :open_handle_z, presence:  { message: "请填写手动开门点坐标" }, :if => :should_validate_basic_data?
  validates :close_handle_x, presence:  { message: "请填写手动关门点坐标" }, :if => :should_validate_basic_data?
  validates :close_handle_y, presence:  { message: "请填写手动关门点坐标" }, :if => :should_validate_basic_data?
  validates :close_handle_z, presence:  { message: "请填写手动关门点坐标" }, :if => :should_validate_basic_data?
  validates :door_weight, presence:  { message: "请填写门重，单位kg" }, :if => :should_validate_basic_data?
  validates :open_angle, presence:  { message: "请填写开门角度" }, :if => :should_validate_basic_data?
  validates :open_time, presence:  { message: "请填写开门时间" }, :if => :should_validate_basic_data?
  validates :close_time, presence:  { message: "请填写开门时间" }, :if => :should_validate_basic_data?
  validates :open_dynamic_friction, presence:  { message: "请填写开门阻力（动摩擦力）" }, :if => :should_validate_basic_data?
  validates :close_dynamic_friction, presence:  { message: "请填写关门阻力（动摩擦力）" }, :if => :should_validate_basic_data?
  validates :open_static_friction, presence:  { message: "请填写开门阻力（静摩擦力）" }, :if => :should_validate_basic_data?
  validates :close_static_friction, presence:  { message: "请填写关门阻力（静摩擦力）" }, :if => :should_validate_basic_data?
  validates :body_a_x, presence:  { message: "请填写车身A点坐标" }, :if => :should_validate_basic_data?
  validates :body_a_y, presence:  { message: "请填写车身A点坐标" }, :if => :should_validate_basic_data?
  validates :body_a_z, presence:  { message: "请填写车身A点坐标" }, :if => :should_validate_basic_data?
  validates :gate_b_x, presence:  { message: "请填写车门B点坐标" }, :if => :should_validate_basic_data?
  validates :gate_b_y, presence:  { message: "请填写车门B点坐标" }, :if => :should_validate_basic_data?
  validates :gate_b_z, presence:  { message: "请填写车门B点坐标" }, :if => :should_validate_basic_data?
  validates :climbing_degree, presence:  { message: "请填写客户定义的汽车爬坡度" }, :if => :should_validate_basic_data?

  #validates :wire_diameter, presence:  { message: "请填写弹簧线径" }, :if => :should_validate_all_data?
  validates :active_coil_num, presence:  { message: "请填写弹簧有效圈数" }, :if => :should_validate_all_data?


  belongs_to :platform
  # belongs_to :platform, inverse_of: :manual_calculations
  # 报错时考虑用
  # belongs_to :user

  # 撑杆一些中间参数
  def vector_og_on_xz # 向量OG在XZ平面的投影长度
    ((centre_gravity_x - hinge_x) ** (2) + (centre_gravity_z - hinge_z) ** (2)) ** (1.0/2)
  end

  def vector_ob_on_xz # 向量OB在XZ平面的投影长度
    sqrt((gate_b_x - hinge_x) ** (2) + (gate_b_z - hinge_z) ** (2))
  end

  def vector_ab # 向量AB的长度,即撑杆关门长度
    ((body_a_x - gate_b_x) ** (2) + (body_a_y - gate_b_y) ** (2) + (body_a_z - gate_b_z) ** (2)) ** (1.0/2)
  end

  def vector_ob_on_xz_x_angle # 向量OB在XZ平面与X轴的夹角（°）
    (180/PI) * atan((gate_b_z - hinge_z) / (gate_b_x - hinge_x))
  end

  def vector_og_on_xz_x_angle # 向量OG在XZ平面与X轴的夹角（°）
    (180/PI) * atan((centre_gravity_z - hinge_z) / (centre_gravity_x - hinge_x))
  end

  def o_centre_gravity_x # 开门重心X坐标
    vector_og_on_xz * cos((open_angle - vector_og_on_xz_x_angle.abs) * PI/180 ) + hinge_x
  end

  def o_centre_gravity_z # 开门重心z坐标
    vector_og_on_xz * sin((open_angle - vector_og_on_xz_x_angle.abs) * PI/180 ) + hinge_z
  end

  def o_gate_b1_x # 开门尾门连接点B1 X坐标
    vector_ob_on_xz * cos((open_angle - vector_ob_on_xz_x_angle.abs) * PI/180 ) + hinge_x
  end

  def o_gate_b1_z # 开门尾门连接点B1 z坐标
    vector_ob_on_xz * sin((open_angle - vector_ob_on_xz_x_angle.abs) * PI/180 ) + hinge_z
  end

  def vector_ob1_length_x # 向量OB1的长度（X方向分量）
    o_gate_b1_x - hinge_x
  end

  def vector_ob1_length_y # 向量OB1的长度（Y方向分量）
    (gate_b_y - hinge_y).abs
  end

  def vector_ob1_length_z # 向量OB1的长度（Z方向分量）
    o_gate_b1_z - hinge_z
  end

  def vector_ab1_length_x # 向量AB1的长度（X方向分量）
    o_gate_b1_x - body_a_x
  end

  def vector_ab1_length_y # 向量AB1的长度（Y方向分量）
    (gate_b_y - body_a_y).abs
  end

  def vector_ab1_length_z # 向量AB1的长度（Z方向分量）
    o_gate_b1_z - body_a_z
  end

  def vector_ab_length_x # 向量AB的长度（X方向分量）
    gate_b_x - body_a_x
  end

  def vector_ab_length_y # 向量AB的长度（Y方向分量）
    gate_b_y - body_a_y
  end

  def vector_ab_length_z # 向量AB的长度（Z方向分量）
    gate_b_z - body_a_z
  end

  def vector_ab1_ob1_on_xz_angle # 向量AB1和OB1在XZ平面的夹角（°）
    (180/PI) * acos((vector_ob1_length_x * vector_ab1_length_x + vector_ob1_length_z * vector_ab1_length_z) / (sqrt(vector_ob1_length_x ** (2) + vector_ob1_length_z ** (2)) * sqrt(vector_ab1_length_x ** (2) + vector_ab1_length_z ** (2))))
  end

  def od_length # 撑杆开门长度
    sqrt((o_gate_b1_x - body_a_x) ** (2) + (gate_b_y - body_a_y) ** (2) + (o_gate_b1_z - body_a_z) ** (2))
  end

  def cd_length # 撑杆关门长度
    sqrt((gate_b_x - body_a_x) ** (2) + (gate_b_y - body_a_y) ** (2) + (gate_b_z - body_a_z) ** (2))
  end

  def working_stroke # 撑杆工作行程
    od_length - cd_length
  end

  def car_climbing_angle # 汽车爬坡角度
    atan(climbing_degree ) * 180 / PI
  end

  def vector_ob_ab_angle # 向量OB和向量AB的夹角
    vector_ob_slope = (gate_b_z - hinge_z) / (gate_b_x - hinge_x) # 向量ob的斜率
    vector_ab_slope = (gate_b_z - body_a_z) / (gate_b_x - body_a_x) # 向量ab的斜率
    (180/PI) * atan((vector_ab_slope - vector_ob_slope) / (1 + vector_ab_slope * vector_ob_slope))
  end

  def vector_ab_xz_angle # 向量AB与XZ平面的线面夹角（空间夹角）
    acos(sqrt(vector_ab_length_x ** (2) + vector_ab_length_z ** (2)) / sqrt(vector_ab_length_x ** (2) + vector_ab_length_y ** (2) + vector_ab_length_z ** (2)) ) * 180 / PI
  end

  def vector_ab1_xz_angle # 向量AB1与XZ平面的线面夹角（空间夹角）
    acos(sqrt(vector_ab1_length_x ** (2) + vector_ab1_length_z ** (2)) / sqrt(vector_ab1_length_x ** (2) + vector_ab1_length_y ** (2) + vector_ab1_length_z ** (2)) ) * 180 / PI
  end

  def od_pole_force_arm  # 开门撑杆力臂
    vector_ob_on_xz * sin(vector_ab1_ob1_on_xz_angle * PI / 180)
  end

  def cd_pole_force_arm  # 关门撑杆力臂
    vector_ob_on_xz * sin(vector_ob_ab_angle * PI / 180)
  end

  def od_min_force # 开门在最高点需求力
    door_weight * 9.8 * (o_centre_gravity_x - hinge_x ) / (2 * od_pole_force_arm) / cos(vector_ab1_xz_angle * PI / 180 )
  end

  def cd_max_force # 关门到开门瞬间时需求力
    door_weight * 9.8 * (centre_gravity_x - hinge_x ) / (2 * cd_pole_force_arm) / cos(vector_ab_xz_angle * PI / 180 )
  end



  # 弹簧计算 #

  # 以下为通用的弹簧参数
  Initial_wire_diameter = 3.8 # 初选线径
  # manual_calculations = ManualCalculation.joins(:platform)
  # 回传所有manual_calculation内含有platform_id的项目, 不会同时查询关联的数据资料，后面会重新生成瓣的查询指令
  manual_calculations = ManualCalculation.includes(:platform)
  # 回传所有manual_calculation内含有platform项目, 会同时查询关联的数据

  # def platform
  #   platform = Platform.find(self.platform_id)
  # end
  # 可以代替上面的代码，但效率低25%


  def spring_cd_length
    cd_length - platform.spring_static_length
  end

  def spring_od_length
    od_length - platform.spring_static_length
  end

  def deformation # 变形量
    deformation = spring_od_length - spring_cd_length
  end

  def max_test_shear_stress # 最大试验切应用力
    max_test_shear_stress = platform.max_tensile_strength * 0.6

  end

  def dynamic_load_allowable_shear_stress # 动负荷许用切应力
    dynamic_load_allowable_shear_stress = platform.max_tensile_strength * 0.57
  end

  def initial_mean_diameter #弹簧初选中径
    initial_mean_diameter = platform.inside_diameter + Initial_wire_diameter
  end

  def mean_diameter # 弹簧中径
    if wire_diameter.present?
      mean_diameter = platform.inside_diameter + wire_diameter
    end
  end

  # 中间参数
  def spring_theoretical_rate # 理论刚度
    spring_theoretical_rate = (cd_max_force - od_min_force) / deformation
  end

  def theoretical_wire_diameter # 理论线径
    c = initial_mean_diameter / Initial_wire_diameter
    k = (4*c-1)/(4*c-4) + (0.615/c)
    theoretical_wire_diameter = (8 * k * initial_mean_diameter * cd_max_force / (PI * dynamic_load_allowable_shear_stress)) ** (1.0/3)
  end

  def theoretical_active_coil_num # 理论有效圈数
    theoretical_active_coil_num = (platform.s_elastic_modulus * (wire_diameter ** (4))) / (8 * (mean_diameter ** (3)) * spring_theoretical_rate)
  end

  def no_solid_position_active_coil_num # 不压并建议有效圈数
    (spring_cd_length - 13) / (wire_diameter + flocking.to_f) - 2
  end

  def spring_rate # 实际刚度
    if self.active_coil_num.present?
      spring_rate = platform.s_elastic_modulus * (wire_diameter ** (4)) / (8 * (mean_diameter ** (3)) * active_coil_num )
    else
      0
    end
  end

  def ht_spring_rate # 高温弹簧刚度
    spring_rate * 0.96
  end

  def theoretical_free_length # 理论自由长度
    if spring_rate.present? && spring_rate != 0
      f1 = od_min_force / spring_rate
      f2 = cd_max_force / spring_rate
      theoretical_free_length = [(spring_od_length + f1), (spring_cd_length + f2)].min
    else
      0
    end
  end

  def total_num # 弹簧总圈数
    if self.active_coil_num.present?
      active_coil_num + 2
    end
  end

  def spring_od_force
    if self.active_coil_num.present? && self.free_length.present?
      spring_od_force = ((free_length - spring_od_length) * spring_rate).round(3)
    else
      spring_od_force = 0
    end
  end

  def spring_cd_force
    if self.active_coil_num.present? && self.free_length.present?
      spring_cd_force = ((free_length - spring_cd_length) * spring_rate).round(3)
    else
      spring_cd_force = 0
    end
  end

  # 弹簧校核用的一些参数

  def safe_spring_solid_position #安全压并高度
    if self.active_coil_num.present? && active_coil_num > 0 &&  total_num.present?
      safe_spring_solid_position = (wire_diameter + flocking.to_f) * total_num + 13
    else
      0
    end
  end

  def spring_solid_position_check # 弹簧压并校核
    if self.free_length.present? && self.active_coil_num.present? && active_coil_num > 0
      if safe_spring_solid_position <= spring_cd_length && safe_spring_solid_position <= free_length
        "弹簧不会压并"
      else
        "弹簧压并！"
      end
    end
  end

  def max_working_shear_stress # 最大工作切应力
    if self.free_length.present?
      c = mean_diameter / wire_diameter
      k = (4*c-1)/(4*c-4) + (0.615/c)
      max_working_shearstress = 8 * mean_diameter * cd_max_force / (PI * (wire_diameter ** (3))) * k
    else
      0
    end
  end

  def max_test_load_deformation # 最大试验负荷弹簧变形量
    if self.free_length.present? && self.active_coil_num.present? && active_coil_num > 0
      hb = total_num * wire_diameter  # 不植绒压并高度
      fb = spring_rate * (free_length - hb) # 弹簧压并负荷
      fs = PI * (wire_diameter ** (3)) / (8 * mean_diameter) * max_test_shear_stress  # 弹簧最大试验负荷
      ffs = [fb,fs].min
      max_test_load_deformation = 8 * (mean_diameter ** (3)) * active_coil_num / (platform.s_elastic_modulus * (wire_diameter ** (4))) * ffs
    else
      0
    end
  end

  def spring_length_check #弹簧长度校核
    if self.free_length.present? && self.active_coil_num.present? && active_coil_num > 0
      l = free_length - max_test_load_deformation
      if l > spring_cd_length
        "弹簧最大试验负荷变形量小于弹簧最大工作变形量（自由长度太长）"
      elsif free_length < spring_od_length
        "弹簧自由长度小于开门弹簧长度"
      else
        "长度可以实现"
      end
    end
  end

  def stress_coefficient # 最大切应力与抗拉强度的比值
    stress_coefficient = max_working_shear_stress / platform.max_tensile_strength
  end

  def spring_attenuation_check # 弹簧衰减校核
    if stress_coefficient > 0.75
      "衰减高，超高衰减标准，需与供应商确认"
    elsif stress_coefficient > 0.7
      "衰减较大，需测试验证后使用"
    else
      "基本无衰减"
    end
  end

  def spring_pitch # 弹簧节距
    if self.free_length.present? && self.active_coil_num.present? && active_coil_num > 0
      spring_pitch = (free_length - 1.5 * wire_diameter) / active_coil_num
    else
      0
    end
  end

  def spring_helix_angle # 弹簧螺旋升角
    if mean_diameter.present?
      (atan(spring_pitch / (PI * mean_diameter)) * 180 / PI).round(3)
    end
  end

  def spring_helix_angle_check # 弹簧螺旋升角校核
    if spring_helix_angle < 5
      "螺旋升角太小，必须大于等于 5"
    elsif spring_helix_angle > 9
      "螺旋升角过大，必须小于等于 9"
    else
      "弹簧螺旋升角满足要求"
    end
  end

  # 撑杆中间参数计算 #

  def oa
    if open_angle % 2 == 0
      oa = open_angle/2 + 1
    else
      oa = open_angle/2 + 2
    end
  end

  def open_angle_arr # 开门角度增量
    open_angle_arr = Array.new(oa) { |e| e = e * 2 }
  end


  def o_gate_b_x_arr # 开门尾门连接点B实时 X坐标
    o_gate_b_x_arr = []
    open_angle_arr.each do |i|
        o_gate_b_x_arr << vector_ob_on_xz * cos((i + vector_ob_on_xz_x_angle) * PI/180 ) + hinge_x
    end
    o_gate_b_x_arr
  end

  def o_gate_b_y_arr # 开门尾门连接点B实时 y坐标
    o_gate_b_y_arr = []
    open_angle_arr.each do |i|
      o_gate_b_y_arr << gate_b_y
    end
    o_gate_b_y_arr
  end

  def o_gate_b_z_arr # 开门尾门连接点B实时 z坐标
    o_gate_b_z_arr = []
    open_angle_arr.each do |i|
      o_gate_b_z_arr << vector_ob_on_xz * sin((i + vector_ob_on_xz_x_angle) * PI/180 ) + hinge_z
    end
    o_gate_b_z_arr
  end

  def pole_length_arr # 撑杆实时长度
    pole_length_arr = []
    # o_gate_b_x_arr.each_index do |i|
    #   x = o_gate_b_x_arr[i]
    #   y = o_gate_b_y_arr[i]
    #   z = o_gate_b_z_arr[i]
    o_gate_b_x_arr.zip(o_gate_b_y_arr,o_gate_b_z_arr) do |x,y,z|
      pole_length_arr << sqrt((x - body_a_x) ** (2) + (y - body_a_y) ** (2) + (z - body_a_z) ** (2) )
    end
    pole_length_arr
  end

  def motor_output_speed_arr # 电机输出转速（r/min） ,假定角度增量为2度
    pla1 = pole_length_arr
    pla1.delete_at(0)
    pla2 = pole_length_arr
    pla2.delete_at(-1)
    motor_output_speed_arr = [2500]
    pla1.zip(pla2) do |i, j|
      motor_output_speed_arr << (i - j) * 60 / (open_time / open_angle * 2 * platform.lead) * platform.gear_transmission_ratio
    end
    motor_output_speed_arr
  end

  def motor_pwm_arr  # PWM调制占空比
    motor_pwm_arr = [0.33333333]
    mos = motor_output_speed_arr
    mos.delete_at(0)
    mos.each do |i|
      motor_pwm_arr << i / platform.rated_speed
    end
    motor_pwm_arr
  end

  def vector_ba_length_x_arr # 向量BA的实时长度（X方向分量）
    vector_ba_length_x_arr = []
    o_gate_b_x_arr.each do |i|
      vector_ba_length_x_arr << body_a_x - i
    end
    vector_ba_length_x_arr
  end

  def vector_ba_length_z_arr # 向量BA的实时长度（Z方向分量）
    vector_ba_length_z_arr = []
    o_gate_b_z_arr.each do |i|
      vector_ba_length_z_arr << body_a_z - i
    end
    vector_ba_length_z_arr
  end

  def vector_ob_length_x_arr # 向量OB的实时长度（X方向分量）
    vector_ob_length_x_arr = []
    o_gate_b_x_arr.each do |i|
      vector_ob_length_x_arr << hinge_x - i
    end
    vector_ob_length_x_arr
  end

  def vector_ob_length_z_arr # 向量OB的实时长度（Z方向分量）
    vector_ob_length_z_arr = []
    o_gate_b_z_arr.each do |i|
      vector_ob_length_z_arr << hinge_z - i
    end
    vector_ob_length_z_arr
  end

  def vector_ba_ob_on_xz_angle_arr # 向量BA和OB在XZ平面的夹角(°)
    vector_ba_ob_on_xz_angle_arr = []
    vector_ob_length_x_arr.zip(vector_ba_length_x_arr,vector_ob_length_z_arr, vector_ba_length_z_arr) do |i,j,k,l|
      vector_ba_ob_on_xz_angle_arr << 180 / PI * acos((i * j + k * l) / (sqrt(i **(2) + k **(2)) * sqrt(j ** (2) + l **(2))))
    end
    vector_ba_ob_on_xz_angle_arr
  end

  def pole_force_arm_arr  # 撑杆力臂
    pole_force_arm_arr = []
    vector_ba_ob_on_xz_angle_arr.each do |i|
      pole_force_arm_arr << vector_ob_on_xz * sin(i * PI / 180)
    end
    pole_force_arm_arr
  end

  def vector_ab_xz_angle_arr # 向量AB与XZ平面的实时线面夹角（空间夹角）
    vector_ab_xz_angle_arr = []
      y = vector_ab_length_y
    vector_ba_length_x_arr.zip(vector_ba_length_z_arr) do |x,z|
      vector_ab_xz_angle_arr << 180 / PI * acos((x * x + z * z) / (sqrt(x ** (2) + y ** (2) + z ** (2)) * sqrt(x ** (2) + z ** (2) ) ))
    end
    vector_ab_xz_angle_arr
  end

  def uphill_gravity_arm_arr # 上坡重力力臂
    uphill_gravity_arm_arr = []
    open_angle_arr.each do |i|
      uphill_gravity_arm_arr << vector_og_on_xz * cos(( vector_og_on_xz_x_angle + i - car_climbing_angle ) * PI / 180)
    end
    uphill_gravity_arm_arr
  end

  def flat_slope_gravity_arm_arr # 平坡重力力臂
    flat_slope_gravity_arm_arr = []
    open_angle_arr.each do |i|
      flat_slope_gravity_arm_arr << vector_og_on_xz * cos(( vector_og_on_xz_x_angle + i ) * PI / 180)
    end
    flat_slope_gravity_arm_arr
  end

  def downhill_gravity_arm_arr # 下坡重力力臂
    downhill_gravity_arm_arr = []
    open_angle_arr.each do |i|
      downhill_gravity_arm_arr << vector_og_on_xz * cos(( vector_og_on_xz_x_angle + i + car_climbing_angle ) * PI / 180)
    end
    downhill_gravity_arm_arr
  end

  #  重力矩 #
  def uphill_gravity_torque_arr # 上坡重力力矩
    uphill_gravity_torque_arr = []
    uphill_gravity_arm_arr.each do |i|
      uphill_gravity_torque_arr << (door_weight * 9.8 * i / 1000).abs
    end
    uphill_gravity_torque_arr
  end

  def flat_slope_gravity_torque_arr # 平坡重力力矩
    flat_slope_gravity_torque_arr = []
    flat_slope_gravity_arm_arr.each do |i|
      flat_slope_gravity_torque_arr << (door_weight * 9.8 * i / 1000).abs
    end
    flat_slope_gravity_torque_arr
  end

  def downhill_gravity_torque_arr # 下坡重力力矩
    downhill_gravity_torque_arr = []
    downhill_gravity_arm_arr.each do |i|
      downhill_gravity_torque_arr << (door_weight * 9.8 * i / 1000).abs
    end
    downhill_gravity_torque_arr
  end

  #  弹簧力矩 以下均为单根力矩 #
  def nt_spring_force_arr # 常温弹簧力中值
    nt_spring_force_arr = []
    pole_length_arr.each do |i|
      nt_spring_force_arr << ( free_length - (spring_cd_length + i - cd_length )) * spring_rate
    end
    nt_spring_force_arr
  end

  def nt_lower_deviation_spring_force_arr # 常温弹簧力下偏差（最小值）
    nt_lower_deviation_spring_force_arr = []
    nt_spring_force_arr.each do |i|
      nt_lower_deviation_spring_force_arr << (i - 30)
    end
    nt_lower_deviation_spring_force_arr
  end

  def nt_upper_deviation_spring_force_arr # 常温弹簧力上偏差（最大值）
    nt_upper_deviation_spring_force_arr = []
    nt_spring_force_arr.each do |i|
      nt_upper_deviation_spring_force_arr << (i + 30)
    end
    nt_upper_deviation_spring_force_arr
  end

  def nt_after_life_spring_force_arr # 常温弹簧力寿命后
    nt_after_life_spring_force_arr = []
    nt_spring_force_arr.each do |i|
      nt_after_life_spring_force_arr << i * (1 - 0.05)
    end
    nt_after_life_spring_force_arr
  end


  def nt_lower_deviation_spring_torque_arr # 常温下偏差弹簧力矩
    nt_lower_deviation_spring_torque_arr = []
    # oa_public_arr.each_index do |i|
    #   j = nt_spring_force_arr[i]
    #   h = pole_force_arm_arr[i]
    #   k = vector_ab_xz_angle_arr[i]   上面这种写法效率很低，在多层迭代取值后运行时间变得很长，而下面的zip方法，而可以提高速度12倍以上
    nt_lower_deviation_spring_force_arr.zip(pole_force_arm_arr,vector_ab_xz_angle_arr) do |j,h,k|
      nt_lower_deviation_spring_torque_arr << j * h * cos(PI / 180 * k) / 1000
    end
    nt_lower_deviation_spring_torque_arr
  end

  def nt_median_spring_torque_arr # 常温中值弹簧力矩
    nt_median_spring_torque_arr = []
    nt_spring_force_arr.zip(pole_force_arm_arr,vector_ab_xz_angle_arr) do |j,h,k|
      nt_median_spring_torque_arr << j * h * cos(PI / 180 * k) / 1000
    end
    nt_median_spring_torque_arr
  end

  def nt_upper_deviation_spring_torque_arr # 常温上偏差弹簧力矩
    nt_upper_deviation_spring_torque_arr = []
    nt_upper_deviation_spring_force_arr.zip(pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k|
      nt_upper_deviation_spring_torque_arr << i * j * cos(PI / 180 * k) / 1000
    end
    nt_upper_deviation_spring_torque_arr
  end

  def nt_after_life_spring_torque_arr # 常温寿命后弹簧力矩
    nt_after_life_spring_torque_arr = []
    nt_after_life_spring_force_arr.zip(pole_force_arm_arr, vector_ab_xz_angle_arr) do |i,j,k|
      nt_after_life_spring_torque_arr << i * j * cos(PI / 180 * k) / 1000
    end
    nt_after_life_spring_torque_arr
  end

  def ht_lower_deviation_spring_torque_arr # 高温下偏差弹簧力矩
    ht_lower_deviation_spring_torque_arr = []
    nt_lower_deviation_spring_torque_arr.each do |i|
      ht_lower_deviation_spring_torque_arr << i * 0.96
    end
    ht_lower_deviation_spring_torque_arr
  end

  def ht_median_spring_torque_arr # 高温中值弹簧力矩
    ht_median_spring_torque_arr = []
    nt_median_spring_torque_arr.each do |i|
      ht_median_spring_torque_arr << i * 0.96
    end
    ht_median_spring_torque_arr
  end

  def ht_upper_deviation_spring_torque_arr # 高温上偏差弹簧力矩
    ht_upper_deviation_spring_torque_arr = []
    nt_upper_deviation_spring_torque_arr.each do |i|
      ht_upper_deviation_spring_torque_arr << i * 0.96
    end
    ht_upper_deviation_spring_torque_arr
  end

  def ht_after_life_spring_torque_arr # 高温寿命后弹簧力矩
    ht_after_life_spring_torque_arr = []
    nt_after_life_spring_torque_arr.each do |i|
      ht_after_life_spring_torque_arr << i * 0.96
    end
    ht_after_life_spring_torque_arr
  end

  # 撑杆动摩擦阻力

  def nt_open_dynamic_friction_arr  # 常温开门摩擦阻力
    nt_open_dynamic_friction_arr = Array.new(oa, open_dynamic_friction)
  end

  def lt_open_dynamic_friction_arr  # 低温开门摩擦阻力
    lt_open_dynamic_friction_arr = Array.new(oa, open_dynamic_friction + 50)
  end

  def ht_open_dynamic_friction_arr  # 低温开门摩擦阻力
    ht_open_dynamic_friction_arr = Array.new(oa, open_dynamic_friction - 50)
  end

  def nt_close_dynamic_friction_arr  # 常温关门摩擦阻力
    nt_close_dynamic_friction_arr = Array.new(oa, close_dynamic_friction)
  end

  def lt_close_dynamic_friction_arr  # 低温关门摩擦阻力
    lt_open_dynamic_friction_arr = Array.new(oa, close_dynamic_friction - 50)
  end

  def ht_close_dynamic_friction_arr  # 低温关门摩擦阻力
    ht_open_dynamic_friction_arr = Array.new(oa, close_dynamic_friction + 50)
  end


  # 撑杆静摩擦阻力

  def nt_open_static_friction_arr  # 常温开门静摩擦阻力
    nt_open_dynamic_friction_arr = Array.new(oa, open_static_friction)
  end

  def lt_open_static_friction_arr  # 低温开门静摩擦阻力
    lt_open_dynamic_friction_arr = Array.new(oa, open_static_friction + 50)
  end

  def ht_open_static_friction_arr  # 高温开门静摩擦阻力
    ht_open_dynamic_friction_arr = Array.new(oa, open_static_friction - 50)
  end

  def nt_close_static_friction_arr  # 常温关门静摩擦阻力
    nt_close_dynamic_friction_arr = Array.new(oa, close_static_friction)
  end

  def lt_close_static_friction_arr  # 低温关门静摩擦阻力
    lt_open_dynamic_friction_arr = Array.new(oa, close_static_friction - 50)
  end

  def ht_close_static_friction_arr  # 高温关门静摩擦阻力
    ht_open_dynamic_friction_arr = Array.new(oa, close_static_friction + 50)
  end

  # 悬停计算  #


  def uphill_lt_lower_deviation_hover_arr # 上坡低温下偏差悬停
    uphill_lt_lower_deviation_hover_arr = []
    uphill_gravity_torque_arr.zip(nt_lower_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_lt_lower_deviation_hover_arr << ((j - i/2) / k / cos(PI / 180 * m ) * 1000).round(3)
    end
    uphill_lt_lower_deviation_hover_arr
  end

  def uphill_lt_median_hover_arr # 上坡低温中值悬停
    uphill_lt_median_hover_arr = []
    uphill_gravity_torque_arr.zip(nt_median_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_lt_median_hover_arr << ((j - i/2) / k / cos(PI / 180 * m ) * 1000).round(3)
    end
    uphill_lt_median_hover_arr
  end

  def uphill_lt_upper_deviation_hover_arr # 上坡低温上偏差悬停
    uphill_lt_upper_deviation_hover_arr = []
    uphill_gravity_torque_arr.zip(nt_upper_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_lt_upper_deviation_hover_arr << ((j - i/2) / k / cos(PI / 180 * m ) * 1000).round(3)
    end
    uphill_lt_upper_deviation_hover_arr
  end

  def uphill_lt_after_life_hover_arr # 上坡低温寿命后悬停
    uphill_lt_after_life_hover_arr = []
    uphill_gravity_torque_arr.zip(nt_after_life_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_lt_after_life_hover_arr << ((j - i/2) / k / cos(PI / 180 * m ) * 1000).round(3)
    end
    uphill_lt_after_life_hover_arr
  end

# 高温

  def uphill_ht_lower_deviation_hover_arr # 上坡高温下偏差悬停
    uphill_ht_lower_deviation_hover_arr = []
    uphill_gravity_torque_arr.zip(ht_lower_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_ht_lower_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    uphill_ht_lower_deviation_hover_arr
  end

  def uphill_ht_median_hover_arr # 上坡高温中值悬停
    uphill_ht_median_hover_arr = []
    uphill_gravity_torque_arr.zip(ht_median_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_ht_median_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    uphill_ht_median_hover_arr
  end

  def uphill_ht_upper_deviation_hover_arr # 上坡高温上偏差悬停
    uphill_ht_upper_deviation_hover_arr = []
    uphill_gravity_torque_arr.zip(ht_upper_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_ht_upper_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    uphill_ht_upper_deviation_hover_arr
  end

  def uphill_ht_after_life_hover_arr # 上坡高温寿命后悬停
    uphill_ht_after_life_hover_arr = []
    uphill_gravity_torque_arr.zip(ht_after_life_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      uphill_ht_after_life_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    uphill_ht_after_life_hover_arr
  end

  # 平坡


  def flat_slope_lt_lower_deviation_hover_arr # 平坡低温下偏差悬停
    flat_slope_lt_lower_deviation_hover_arr = []
    flat_slope_gravity_torque_arr.zip(nt_lower_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_lt_lower_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_lt_lower_deviation_hover_arr
  end

  def flat_slope_lt_median_hover_arr # 平坡低温中值悬停
    flat_slope_lt_median_hover_arr = []
    flat_slope_gravity_torque_arr.zip(nt_median_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_lt_median_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_lt_median_hover_arr
  end

  def flat_slope_lt_upper_deviation_hover_arr # 平坡低温上偏差悬停
    flat_slope_lt_upper_deviation_hover_arr = []
    flat_slope_gravity_torque_arr.zip(nt_upper_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_lt_upper_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_lt_upper_deviation_hover_arr
  end

  def flat_slope_lt_after_life_hover_arr # 平坡低温寿命后悬停
    flat_slope_lt_after_life_hover_arr = []
    flat_slope_gravity_torque_arr.zip(nt_after_life_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_lt_after_life_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_lt_after_life_hover_arr
  end

# 高温

  def flat_slope_ht_lower_deviation_hover_arr # 平坡高温下偏差悬停
    flat_slope_ht_lower_deviation_hover_arr = []
    flat_slope_gravity_torque_arr.zip(ht_lower_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_ht_lower_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_ht_lower_deviation_hover_arr
  end

  def flat_slope_ht_median_hover_arr # 平坡高温中值悬停
    flat_slope_ht_median_hover_arr = []
    flat_slope_gravity_torque_arr.zip(ht_median_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_ht_median_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_ht_median_hover_arr
  end

  def flat_slope_ht_upper_deviation_hover_arr # 平坡高温上偏差悬停
    flat_slope_ht_upper_deviation_hover_arr = []
    flat_slope_gravity_torque_arr.zip(ht_upper_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_ht_upper_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_ht_upper_deviation_hover_arr
  end

  def flat_slope_ht_after_life_hover_arr # 平坡高温寿命后悬停
    flat_slope_ht_after_life_hover_arr = []
    flat_slope_gravity_torque_arr.zip(ht_after_life_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      flat_slope_ht_after_life_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    flat_slope_ht_after_life_hover_arr
  end

# 下坡


  def downhill_lt_lower_deviation_hover_arr # 下坡低温下偏差悬停
    downhill_lt_lower_deviation_hover_arr = []
    downhill_gravity_torque_arr.zip(nt_lower_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_lt_lower_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_lt_lower_deviation_hover_arr
  end

  def downhill_lt_median_hover_arr # 下坡低温中值悬停
    downhill_lt_median_hover_arr = []
    downhill_gravity_torque_arr.zip(nt_median_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_lt_median_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_lt_median_hover_arr
  end

  def downhill_lt_upper_deviation_hover_arr # 下坡低温上偏差悬停
    downhill_lt_upper_deviation_hover_arr = []
    downhill_gravity_torque_arr.zip(nt_upper_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_lt_upper_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_lt_upper_deviation_hover_arr
  end

  def downhill_lt_after_life_hover_arr # 下坡低温寿命后悬停
    downhill_lt_after_life_hover_arr = []
    downhill_gravity_torque_arr.zip(nt_after_life_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_lt_after_life_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_lt_after_life_hover_arr
  end

# 高温

  def downhill_ht_lower_deviation_hover_arr # 下坡高温下偏差悬停
    downhill_ht_lower_deviation_hover_arr = []
    downhill_gravity_torque_arr.zip(ht_lower_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_ht_lower_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_ht_lower_deviation_hover_arr
  end

  def downhill_ht_median_hover_arr # 下坡高温中值悬停
    downhill_ht_median_hover_arr = []
    downhill_gravity_torque_arr.zip(ht_median_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_ht_median_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_ht_median_hover_arr
  end

  def downhill_ht_upper_deviation_hover_arr # 下坡高温上偏差悬停
    downhill_ht_upper_deviation_hover_arr = []
    downhill_gravity_torque_arr.zip(ht_upper_deviation_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_ht_upper_deviation_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_ht_upper_deviation_hover_arr
  end

  def downhill_ht_after_life_hover_arr # 下坡高温寿命后悬停
    downhill_ht_after_life_hover_arr = []
    downhill_gravity_torque_arr.zip(ht_after_life_spring_torque_arr, pole_force_arm_arr,vector_ab_xz_angle_arr) do |i,j,k,m|
      downhill_ht_after_life_hover_arr << (j - i/2) / k / cos(PI / 180 * m ) * 1000
    end
    downhill_ht_after_life_hover_arr
  end

  # 手动开门力 #

  # 撑杆阻力矩

  def lt_open_resistance_torque_arr # 低温开门阻力矩
    lt_open_resistance_torque_arr = []
    pole_force_arm_arr.zip(lt_open_dynamic_friction_arr,vector_ab_xz_angle_arr) do |i,j,k|
      lt_open_resistance_torque_arr << i * j * cos(PI/180 * k) / 1000
    end
    lt_open_resistance_torque_arr
  end

  def lt_close_resistance_torque_arr # 低温关门阻力矩
    lt_close_resistance_torque_arr = []
    pole_force_arm_arr.zip(lt_close_dynamic_friction_arr,vector_ab_xz_angle_arr) do |i,j,k|
      lt_close_resistance_torque_arr << i * j * cos(PI/180 * k) / 1000
    end
    lt_close_resistance_torque_arr
  end

  def nt_open_resistance_torque_arr # 常温开门阻力矩
    nt_open_resistance_torque_arr = []
    pole_force_arm_arr.zip(nt_open_dynamic_friction_arr,vector_ab_xz_angle_arr) do |i,j,k|
      nt_open_resistance_torque_arr << i * j * cos(PI/180 * k) / 1000
    end
    nt_open_resistance_torque_arr
  end

  def nt_close_resistance_torque_arr # 常温关门阻力矩
    nt_close_resistance_torque_arr = []
    pole_force_arm_arr.zip(nt_close_dynamic_friction_arr,vector_ab_xz_angle_arr) do |i,j,k|
      nt_close_resistance_torque_arr << i * j * cos(PI/180 * k) / 1000
    end
    nt_close_resistance_torque_arr
  end

  def ht_open_resistance_torque_arr # 高温开门阻力矩
    ht_open_resistance_torque_arr = []
    pole_force_arm_arr.zip(ht_open_dynamic_friction_arr,vector_ab_xz_angle_arr) do |i,j,k|
      ht_open_resistance_torque_arr << i * j * cos(PI/180 * k) / 1000
    end
    ht_open_resistance_torque_arr
  end

  def ht_close_resistance_torque_arr # 高温关门阻力矩
    ht_close_resistance_torque_arr = []
    pole_force_arm_arr.zip(ht_close_dynamic_friction_arr,vector_ab_xz_angle_arr) do |i,j,k|
      ht_close_resistance_torque_arr << i * j * cos(PI/180 * k) / 1000
    end
    ht_close_resistance_torque_arr
  end

  # 手动作业点OH上度
  def open_handle_length #手动开门作用点到旋转中心长度
    oh = sqrt((open_handle_x - hinge_x) **(2) + ( open_handle_z - hinge_z ) **(2))
  end

  def close_handle_length #手动关门作用点到旋转中心长度
    ch = sqrt((close_handle_x - hinge_x) **(2) + ( close_handle_z - hinge_z ) **(2))
  end

  #  上坡

  def uphill_lt_lower_deviation_manually_open_door_arr  # 上坡低温下偏差手动开门力
    uphill_lt_lower_deviation_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      uphill_lt_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_lt_lower_deviation_manually_open_door_arr
  end

  def uphill_lt_median_manually_open_door_arr  # 上坡低温中值手动开门力
    uphill_lt_median_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      uphill_lt_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_lt_median_manually_open_door_arr
  end

  def uphill_lt_upper_deviation_manually_open_door_arr  # 上坡低温上偏差手动开门力
    uphill_lt_upper_deviation_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      uphill_lt_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_lt_upper_deviation_manually_open_door_arr
  end

  def uphill_lt_after_life_manually_open_door_arr  # 上坡低温寿命后手动开门力
    uphill_lt_after_life_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      uphill_lt_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_lt_after_life_manually_open_door_arr
  end


  def uphill_nt_lower_deviation_manually_open_door_arr  # 上坡常温下偏差手动开门力
    uphill_nt_lower_deviation_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      uphill_nt_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_nt_lower_deviation_manually_open_door_arr
  end

  def uphill_nt_median_manually_open_door_arr  # 上坡常温中值手动开门力
    uphill_nt_median_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      uphill_nt_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_nt_median_manually_open_door_arr
  end

  def uphill_nt_upper_deviation_manually_open_door_arr  # 上坡常温上偏差手动开门力
    uphill_nt_upper_deviation_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      uphill_nt_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_nt_upper_deviation_manually_open_door_arr
  end

  def uphill_nt_after_life_manually_open_door_arr  # 上坡常温寿命后手动开门力
    uphill_nt_after_life_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      uphill_nt_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_nt_after_life_manually_open_door_arr
  end

  def uphill_ht_lower_deviation_manually_open_door_arr  # 上坡高温下偏差手动开门力
    uphill_ht_lower_deviation_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_lower_deviation_spring_torque_arr) do |i,j,k|
      uphill_ht_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_ht_lower_deviation_manually_open_door_arr
  end

  def uphill_ht_median_manually_open_door_arr  # 上坡高温中值手动开门力
    uphill_ht_median_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_median_spring_torque_arr) do |i,j,k|
      uphill_ht_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_ht_median_manually_open_door_arr
  end

  def uphill_ht_upper_deviation_manually_open_door_arr  # 上坡高温上偏差手动开门力
    uphill_ht_upper_deviation_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_upper_deviation_spring_torque_arr) do |i,j,k|
      uphill_ht_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_ht_upper_deviation_manually_open_door_arr
  end

  def uphill_ht_after_life_manually_open_door_arr  # 上坡高温寿命后手动开门力
    uphill_ht_after_life_manually_open_door_arr = []
    uphill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_after_life_spring_torque_arr) do |i,j,k|
      uphill_ht_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    uphill_ht_after_life_manually_open_door_arr
  end

  #  平坡

  def flat_slope_lt_lower_deviation_manually_open_door_arr  # 平坡低温下偏差手动开门力
    flat_slope_lt_lower_deviation_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_lt_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_lt_lower_deviation_manually_open_door_arr
  end

  def flat_slope_lt_median_manually_open_door_arr  # 平坡低温中值手动开门力
    flat_slope_lt_median_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      flat_slope_lt_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_lt_median_manually_open_door_arr
  end

  def flat_slope_lt_upper_deviation_manually_open_door_arr  # 平坡低温上偏差手动开门力
    flat_slope_lt_upper_deviation_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_lt_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_lt_upper_deviation_manually_open_door_arr
  end

  def flat_slope_lt_after_life_manually_open_door_arr  # 平坡低温寿命后手动开门力
    flat_slope_lt_after_life_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      flat_slope_lt_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_lt_after_life_manually_open_door_arr
  end

  def flat_slope_nt_lower_deviation_manually_open_door_arr  # 平坡常温下偏差手动开门力
    flat_slope_nt_lower_deviation_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_nt_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_nt_lower_deviation_manually_open_door_arr
  end

  def flat_slope_nt_median_manually_open_door_arr  # 平坡常温中值手动开门力
    flat_slope_nt_median_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      flat_slope_nt_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_nt_median_manually_open_door_arr
  end

  def flat_slope_nt_upper_deviation_manually_open_door_arr  # 平坡常温上偏差手动开门力
    flat_slope_nt_upper_deviation_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_nt_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_nt_upper_deviation_manually_open_door_arr
  end

  def flat_slope_nt_after_life_manually_open_door_arr  # 平坡常温寿命后手动开门力
    flat_slope_nt_after_life_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      flat_slope_nt_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_nt_after_life_manually_open_door_arr
  end

  def flat_slope_ht_lower_deviation_manually_open_door_arr  # 平坡高温下偏差手动开门力
    flat_slope_ht_lower_deviation_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_lower_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_ht_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_ht_lower_deviation_manually_open_door_arr
  end

  def flat_slope_ht_median_manually_open_door_arr  # 平坡高温中值手动开门力
    flat_slope_ht_median_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_median_spring_torque_arr) do |i,j,k|
      flat_slope_ht_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_ht_median_manually_open_door_arr
  end

  def flat_slope_ht_upper_deviation_manually_open_door_arr  # 平坡高温上偏差手动开门力
    flat_slope_ht_upper_deviation_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_upper_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_ht_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_ht_upper_deviation_manually_open_door_arr
  end

  def flat_slope_ht_after_life_manually_open_door_arr  # 平坡高温寿命后手动开门力
    flat_slope_ht_after_life_manually_open_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_after_life_spring_torque_arr) do |i,j,k|
      flat_slope_ht_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    flat_slope_ht_after_life_manually_open_door_arr
  end


  #  下坡

  def downhill_lt_lower_deviation_manually_open_door_arr  # 下坡低温下偏差手动开门力
    downhill_lt_lower_deviation_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      downhill_lt_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_lt_lower_deviation_manually_open_door_arr
  end

  def downhill_lt_median_manually_open_door_arr  # 下坡低温中值手动开门力
    downhill_lt_median_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      downhill_lt_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_lt_median_manually_open_door_arr
  end

  def downhill_lt_upper_deviation_manually_open_door_arr  # 下坡低温上偏差手动开门力
    downhill_lt_upper_deviation_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      downhill_lt_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_lt_upper_deviation_manually_open_door_arr
  end

  def downhill_lt_after_life_manually_open_door_arr  # 下坡低温寿命后手动开门力
    downhill_lt_after_life_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(lt_open_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      downhill_lt_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_lt_after_life_manually_open_door_arr
  end

  def downhill_nt_lower_deviation_manually_open_door_arr  # 下坡常温下偏差手动开门力
    downhill_nt_lower_deviation_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      downhill_nt_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_nt_lower_deviation_manually_open_door_arr
  end

  def downhill_nt_median_manually_open_door_arr  # 下坡常温中值手动开门力
    downhill_nt_median_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      downhill_nt_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_nt_median_manually_open_door_arr
  end

  def downhill_nt_upper_deviation_manually_open_door_arr  # 下坡常温上偏差手动开门力
    downhill_nt_upper_deviation_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      downhill_nt_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_nt_upper_deviation_manually_open_door_arr
  end

  def downhill_nt_after_life_manually_open_door_arr  # 下坡常温寿命后手动开门力
    downhill_nt_after_life_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(nt_open_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      downhill_nt_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_nt_after_life_manually_open_door_arr
  end

  def downhill_ht_lower_deviation_manually_open_door_arr  # 下坡高温下偏差手动开门力
    downhill_ht_lower_deviation_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_lower_deviation_spring_torque_arr) do |i,j,k|
      downhill_ht_lower_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_ht_lower_deviation_manually_open_door_arr
  end

  def downhill_ht_median_manually_open_door_arr  # 下坡高温中值手动开门力
    downhill_ht_median_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_median_spring_torque_arr) do |i,j,k|
      downhill_ht_median_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_ht_median_manually_open_door_arr
  end

  def downhill_ht_upper_deviation_manually_open_door_arr  # 下坡高温上偏差手动开门力
    downhill_ht_upper_deviation_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_upper_deviation_spring_torque_arr) do |i,j,k|
      downhill_ht_upper_deviation_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_ht_upper_deviation_manually_open_door_arr
  end

  def downhill_ht_after_life_manually_open_door_arr  # 下坡高温寿命后手动开门力
    downhill_ht_after_life_manually_open_door_arr = []
    downhill_gravity_torque_arr.zip(ht_open_resistance_torque_arr,ht_after_life_spring_torque_arr) do |i,j,k|
      downhill_ht_after_life_manually_open_door_arr << (i + j*2 - k*2) / open_handle_length * 1000
    end
    downhill_ht_after_life_manually_open_door_arr
  end


  #  手动关门力  #

  #  上坡

  def uphill_lt_lower_deviation_manually_close_door_arr  # 上坡低温下偏差手动关门力
    uphill_lt_lower_deviation_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      uphill_lt_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_lt_lower_deviation_manually_close_door_arr
  end

  def uphill_lt_median_manually_close_door_arr  # 上坡低温中值手动关门力
    uphill_lt_median_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      uphill_lt_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_lt_median_manually_close_door_arr
  end

  def uphill_lt_upper_deviation_manually_close_door_arr  # 上坡低温上偏差手动关门力
    uphill_lt_upper_deviation_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      uphill_lt_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_lt_upper_deviation_manually_close_door_arr
  end

  def uphill_lt_after_life_manually_close_door_arr  # 上坡低温寿命后手动关门力
    uphill_lt_after_life_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      uphill_lt_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_lt_after_life_manually_close_door_arr
  end


  def uphill_nt_lower_deviation_manually_close_door_arr  # 上坡常温下偏差手动关门力
    uphill_nt_lower_deviation_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      uphill_nt_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_nt_lower_deviation_manually_close_door_arr
  end

  def uphill_nt_median_manually_close_door_arr  # 上坡常温中值手动关门力
    uphill_nt_median_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      uphill_nt_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_nt_median_manually_close_door_arr
  end

  def uphill_nt_upper_deviation_manually_close_door_arr  # 上坡常温上偏差手动关门力
    uphill_nt_upper_deviation_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      uphill_nt_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_nt_upper_deviation_manually_close_door_arr
  end

  def uphill_nt_after_life_manually_close_door_arr  # 上坡常温寿命后手动关门力
    uphill_nt_after_life_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      uphill_nt_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_nt_after_life_manually_close_door_arr
  end

  def uphill_ht_lower_deviation_manually_close_door_arr  # 上坡高温下偏差手动关门力
    uphill_ht_lower_deviation_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_lower_deviation_spring_torque_arr) do |i,j,k|
      uphill_ht_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_ht_lower_deviation_manually_close_door_arr
  end

  def uphill_ht_median_manually_close_door_arr  # 上坡高温中值手动关门力
    uphill_ht_median_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_median_spring_torque_arr) do |i,j,k|
      uphill_ht_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_ht_median_manually_close_door_arr
  end

  def uphill_ht_upper_deviation_manually_close_door_arr  # 上坡高温上偏差手动关门力
    uphill_ht_upper_deviation_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_upper_deviation_spring_torque_arr) do |i,j,k|
      uphill_ht_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_ht_upper_deviation_manually_close_door_arr
  end

  def uphill_ht_after_life_manually_close_door_arr  # 上坡高温寿命后手动关门力
    uphill_ht_after_life_manually_close_door_arr = []
    uphill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_after_life_spring_torque_arr) do |i,j,k|
      uphill_ht_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    uphill_ht_after_life_manually_close_door_arr
  end

  #  平坡

  def flat_slope_lt_lower_deviation_manually_close_door_arr  # 平坡低温下偏差手动关门力
    flat_slope_lt_lower_deviation_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_lt_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_lt_lower_deviation_manually_close_door_arr
  end

  def flat_slope_lt_median_manually_close_door_arr  # 平坡低温中值手动关门力
    flat_slope_lt_median_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      flat_slope_lt_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_lt_median_manually_close_door_arr
  end

  def flat_slope_lt_upper_deviation_manually_close_door_arr  # 平坡低温上偏差手动关门力
    flat_slope_lt_upper_deviation_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_lt_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_lt_upper_deviation_manually_close_door_arr
  end

  def flat_slope_lt_after_life_manually_close_door_arr  # 平坡低温寿命后手动关门力
    flat_slope_lt_after_life_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      flat_slope_lt_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_lt_after_life_manually_close_door_arr
  end

  def flat_slope_nt_lower_deviation_manually_close_door_arr  # 平坡常温下偏差手动关门力
    flat_slope_nt_lower_deviation_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_nt_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_nt_lower_deviation_manually_close_door_arr
  end

  def flat_slope_nt_median_manually_close_door_arr  # 平坡常温中值手动关门力
    flat_slope_nt_median_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      flat_slope_nt_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_nt_median_manually_close_door_arr
  end

  def flat_slope_nt_upper_deviation_manually_close_door_arr  # 平坡常温上偏差手动关门力
    flat_slope_nt_upper_deviation_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_nt_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_nt_upper_deviation_manually_close_door_arr
  end

  def flat_slope_nt_after_life_manually_close_door_arr  # 平坡常温寿命后手动关门力
    flat_slope_nt_after_life_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      flat_slope_nt_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_nt_after_life_manually_close_door_arr
  end

  def flat_slope_ht_lower_deviation_manually_close_door_arr  # 平坡高温下偏差手动关门力
    flat_slope_ht_lower_deviation_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_lower_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_ht_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_ht_lower_deviation_manually_close_door_arr
  end

  def flat_slope_ht_median_manually_close_door_arr  # 平坡高温中值手动关门力
    flat_slope_ht_median_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_median_spring_torque_arr) do |i,j,k|
      flat_slope_ht_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_ht_median_manually_close_door_arr
  end

  def flat_slope_ht_upper_deviation_manually_close_door_arr  # 平坡高温上偏差手动关门力
    flat_slope_ht_upper_deviation_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_upper_deviation_spring_torque_arr) do |i,j,k|
      flat_slope_ht_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_ht_upper_deviation_manually_close_door_arr
  end

  def flat_slope_ht_after_life_manually_close_door_arr  # 平坡高温寿命后手动关门力
    flat_slope_ht_after_life_manually_close_door_arr = []
    flat_slope_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_after_life_spring_torque_arr) do |i,j,k|
      flat_slope_ht_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    flat_slope_ht_after_life_manually_close_door_arr
  end


  #  下坡

  def downhill_lt_lower_deviation_manually_close_door_arr  # 下坡低温下偏差手动关门力
    downhill_lt_lower_deviation_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      downhill_lt_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_lt_lower_deviation_manually_close_door_arr
  end

  def downhill_lt_median_manually_close_door_arr  # 下坡低温中值手动关门力
    downhill_lt_median_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      downhill_lt_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_lt_median_manually_close_door_arr
  end

  def downhill_lt_upper_deviation_manually_close_door_arr  # 下坡低温上偏差手动关门力
    downhill_lt_upper_deviation_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      downhill_lt_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_lt_upper_deviation_manually_close_door_arr
  end

  def downhill_lt_after_life_manually_close_door_arr  # 下坡低温寿命后手动关门力
    downhill_lt_after_life_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(lt_close_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      downhill_lt_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_lt_after_life_manually_close_door_arr
  end

  def downhill_nt_lower_deviation_manually_close_door_arr  # 下坡常温下偏差手动关门力
    downhill_nt_lower_deviation_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_lower_deviation_spring_torque_arr) do |i,j,k|
      downhill_nt_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_nt_lower_deviation_manually_close_door_arr
  end

  def downhill_nt_median_manually_close_door_arr  # 下坡常温中值手动关门力
    downhill_nt_median_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_median_spring_torque_arr) do |i,j,k|
      downhill_nt_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_nt_median_manually_close_door_arr
  end

  def downhill_nt_upper_deviation_manually_close_door_arr  # 下坡常温上偏差手动关门力
    downhill_nt_upper_deviation_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_upper_deviation_spring_torque_arr) do |i,j,k|
      downhill_nt_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_nt_upper_deviation_manually_close_door_arr
  end

  def downhill_nt_after_life_manually_close_door_arr  # 下坡常温寿命后手动关门力
    downhill_nt_after_life_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(nt_close_resistance_torque_arr,nt_after_life_spring_torque_arr) do |i,j,k|
      downhill_nt_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_nt_after_life_manually_close_door_arr
  end

  def downhill_ht_lower_deviation_manually_close_door_arr  # 下坡高温下偏差手动关门力
    downhill_ht_lower_deviation_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_lower_deviation_spring_torque_arr) do |i,j,k|
      downhill_ht_lower_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_ht_lower_deviation_manually_close_door_arr
  end

  def downhill_ht_median_manually_close_door_arr  # 下坡高温中值手动关门力
    downhill_ht_median_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_median_spring_torque_arr) do |i,j,k|
      downhill_ht_median_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_ht_median_manually_close_door_arr
  end

  def downhill_ht_upper_deviation_manually_close_door_arr  # 下坡高温上偏差手动关门力
    downhill_ht_upper_deviation_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_upper_deviation_spring_torque_arr) do |i,j,k|
      downhill_ht_upper_deviation_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_ht_upper_deviation_manually_close_door_arr
  end

  def downhill_ht_after_life_manually_close_door_arr  # 下坡高温寿命后手动关门力
    downhill_ht_after_life_manually_close_door_arr = []
    downhill_gravity_torque_arr.zip(ht_close_resistance_torque_arr,ht_after_life_spring_torque_arr) do |i,j,k|
      downhill_ht_after_life_manually_close_door_arr << ( k*2 - j*2 - i ) / close_handle_length * 1000
    end
    downhill_ht_after_life_manually_close_door_arr
  end


  #  开门减速箱扭矩  #

  def uphill_need_pole_thrust_force_arr  # 上坡需要的撑杆推力
    uphill_need_pole_thrust_force_arr = []
    pole_force_arm_arr.zip(uphill_gravity_torque_arr,vector_ab_xz_angle_arr) do |i,j,k|
      uphill_need_pole_thrust_force_arr << j / (i * 2) / cos(PI / 180 * k) * 1000
    end
    uphill_need_pole_thrust_force_arr
  end

  def flat_slope_need_pole_thrust_force_arr  # 平坡需要的撑杆推力
    flat_slope_need_pole_thrust_force_arr = []
    pole_force_arm_arr.zip(flat_slope_gravity_torque_arr,vector_ab_xz_angle_arr) do |i,j,k|
      flat_slope_need_pole_thrust_force_arr << j / (i * 2) / cos(PI / 180 * k) * 1000
    end
    flat_slope_need_pole_thrust_force_arr
  end

  def downhill_need_pole_thrust_force_arr  # 下坡需要的撑杆推力
    downhill_need_pole_thrust_force_arr = []
    pole_force_arm_arr.zip(downhill_gravity_torque_arr,vector_ab_xz_angle_arr) do |i,j,k|
      downhill_need_pole_thrust_force_arr << j / (i * 2) / cos(PI / 180 * k) * 1000
    end
    downhill_need_pole_thrust_force_arr
  end


  #  上坡

  def uphill_lt_lower_deviation_open_door_gearbox_torque_arr # 上坡低温下偏差开门减速箱扭矩
    uphill_lt_lower_deviation_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      uphill_lt_lower_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_lower_deviation_open_door_gearbox_torque_arr
  end

  def uphill_lt_median_open_door_gearbox_torque_arr # 上坡低温中值开门减速箱扭矩
    uphill_lt_median_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      uphill_lt_median_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_median_open_door_gearbox_torque_arr
  end

  def uphill_lt_upper_deviation_open_door_gearbox_torque_arr # 上坡低温上偏差开门减速箱扭矩
    uphill_lt_upper_deviation_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      uphill_lt_upper_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_upper_deviation_open_door_gearbox_torque_arr
  end

  def uphill_lt_after_life_open_door_gearbox_torque_arr # 上坡低温寿命后开门减速箱扭矩
    uphill_lt_after_life_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      uphill_lt_after_life_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_after_life_open_door_gearbox_torque_arr
  end

  def uphill_nt_lower_deviation_open_door_gearbox_torque_arr # 上坡常温下偏差开门减速箱扭矩
    uphill_nt_lower_deviation_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      uphill_nt_lower_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_lower_deviation_open_door_gearbox_torque_arr
  end

  def uphill_nt_median_open_door_gearbox_torque_arr # 上坡常温中值开门减速箱扭矩
    uphill_nt_median_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      uphill_nt_median_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_median_open_door_gearbox_torque_arr
  end

  def uphill_nt_upper_deviation_open_door_gearbox_torque_arr # 上坡常温上偏差开门减速箱扭矩
    uphill_nt_upper_deviation_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      uphill_nt_upper_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_upper_deviation_open_door_gearbox_torque_arr
  end

  def uphill_nt_after_life_open_door_gearbox_torque_arr # 上坡常温寿命后开门减速箱扭矩
    uphill_nt_after_life_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      uphill_nt_after_life_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_after_life_open_door_gearbox_torque_arr
  end

  def uphill_ht_lower_deviation_open_door_gearbox_torque_arr # 上坡高温下偏差开门减速箱扭矩
    uphill_ht_lower_deviation_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      uphill_ht_lower_deviation_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_lower_deviation_open_door_gearbox_torque_arr
  end

  def uphill_ht_median_open_door_gearbox_torque_arr # 上坡高温中值开门减速箱扭矩
    uphill_ht_median_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      uphill_ht_median_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_median_open_door_gearbox_torque_arr
  end

  def uphill_ht_upper_deviation_open_door_gearbox_torque_arr # 上坡高温上偏差开门减速箱扭矩
    uphill_ht_upper_deviation_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      uphill_ht_upper_deviation_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_upper_deviation_open_door_gearbox_torque_arr
  end

  def uphill_ht_after_life_open_door_gearbox_torque_arr # 上坡高温寿命后开门减速箱扭矩
    uphill_ht_after_life_open_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      uphill_ht_after_life_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_after_life_open_door_gearbox_torque_arr
  end

  # 平坡

  def flat_slope_lt_lower_deviation_open_door_gearbox_torque_arr # 平坡低温下偏差开门减速箱扭矩
    flat_slope_lt_lower_deviation_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      flat_slope_lt_lower_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_lower_deviation_open_door_gearbox_torque_arr
  end

  def flat_slope_lt_median_open_door_gearbox_torque_arr # 平坡低温中值开门减速箱扭矩
    flat_slope_lt_median_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      flat_slope_lt_median_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_median_open_door_gearbox_torque_arr
  end

  def flat_slope_lt_upper_deviation_open_door_gearbox_torque_arr # 平坡低温上偏差开门减速箱扭矩
    flat_slope_lt_upper_deviation_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      flat_slope_lt_upper_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_upper_deviation_open_door_gearbox_torque_arr
  end

  def flat_slope_lt_after_life_open_door_gearbox_torque_arr # 平坡低温寿命后开门减速箱扭矩
    flat_slope_lt_after_life_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      flat_slope_lt_after_life_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_after_life_open_door_gearbox_torque_arr
  end

  def flat_slope_nt_lower_deviation_open_door_gearbox_torque_arr # 平坡常温下偏差开门减速箱扭矩
    flat_slope_nt_lower_deviation_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      flat_slope_nt_lower_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_lower_deviation_open_door_gearbox_torque_arr
  end

  def flat_slope_nt_median_open_door_gearbox_torque_arr # 平坡常温中值开门减速箱扭矩
    flat_slope_nt_median_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      flat_slope_nt_median_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_median_open_door_gearbox_torque_arr
  end

  def flat_slope_nt_upper_deviation_open_door_gearbox_torque_arr # 平坡常温上偏差开门减速箱扭矩
    flat_slope_nt_upper_deviation_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      flat_slope_nt_upper_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_upper_deviation_open_door_gearbox_torque_arr
  end

  def flat_slope_nt_after_life_open_door_gearbox_torque_arr # 平坡常温寿命后开门减速箱扭矩
    flat_slope_nt_after_life_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      flat_slope_nt_after_life_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_after_life_open_door_gearbox_torque_arr
  end

  def flat_slope_ht_lower_deviation_open_door_gearbox_torque_arr # 平坡高温下偏差开门减速箱扭矩
    flat_slope_ht_lower_deviation_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      flat_slope_ht_lower_deviation_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_lower_deviation_open_door_gearbox_torque_arr
  end

  def flat_slope_ht_median_open_door_gearbox_torque_arr # 平坡高温中值开门减速箱扭矩
    flat_slope_ht_median_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      flat_slope_ht_median_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_median_open_door_gearbox_torque_arr
  end

  def flat_slope_ht_upper_deviation_open_door_gearbox_torque_arr # 平坡高温上偏差开门减速箱扭矩
    flat_slope_ht_upper_deviation_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      flat_slope_ht_upper_deviation_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_upper_deviation_open_door_gearbox_torque_arr
  end

  def flat_slope_ht_after_life_open_door_gearbox_torque_arr # 平坡高温寿命后开门减速箱扭矩
    flat_slope_ht_after_life_open_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      flat_slope_ht_after_life_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_after_life_open_door_gearbox_torque_arr
  end

  # 下坡

  def downhill_lt_lower_deviation_open_door_gearbox_torque_arr # 平坡低温下偏差开门减速箱扭矩
    downhill_lt_lower_deviation_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      downhill_lt_lower_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_lower_deviation_open_door_gearbox_torque_arr
  end

  def downhill_lt_median_open_door_gearbox_torque_arr # 平坡低温中值开门减速箱扭矩
    downhill_lt_median_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      downhill_lt_median_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_median_open_door_gearbox_torque_arr
  end

  def downhill_lt_upper_deviation_open_door_gearbox_torque_arr # 平坡低温上偏差开门减速箱扭矩
    downhill_lt_upper_deviation_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      downhill_lt_upper_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_upper_deviation_open_door_gearbox_torque_arr
  end

  def downhill_lt_after_life_open_door_gearbox_torque_arr # 平坡低温寿命后开门减速箱扭矩
    downhill_lt_after_life_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      downhill_lt_after_life_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_after_life_open_door_gearbox_torque_arr
  end

  def downhill_nt_lower_deviation_open_door_gearbox_torque_arr # 平坡常温下偏差开门减速箱扭矩
    downhill_nt_lower_deviation_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      downhill_nt_lower_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_lower_deviation_open_door_gearbox_torque_arr
  end

  def downhill_nt_median_open_door_gearbox_torque_arr # 平坡常温中值开门减速箱扭矩
    downhill_nt_median_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      downhill_nt_median_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_median_open_door_gearbox_torque_arr
  end

  def downhill_nt_upper_deviation_open_door_gearbox_torque_arr # 平坡常温上偏差开门减速箱扭矩
    downhill_nt_upper_deviation_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      downhill_nt_upper_deviation_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_upper_deviation_open_door_gearbox_torque_arr
  end

  def downhill_nt_after_life_open_door_gearbox_torque_arr # 平坡常温寿命后开门减速箱扭矩
    downhill_nt_after_life_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      downhill_nt_after_life_open_door_gearbox_torque_arr << (i + j - k) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_after_life_open_door_gearbox_torque_arr
  end

  def downhill_ht_lower_deviation_open_door_gearbox_torque_arr # 平坡高温下偏差开门减速箱扭矩
    downhill_ht_lower_deviation_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      downhill_ht_lower_deviation_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_lower_deviation_open_door_gearbox_torque_arr
  end

  def downhill_ht_median_open_door_gearbox_torque_arr # 平坡高温中值开门减速箱扭矩
    downhill_ht_median_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      downhill_ht_median_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_median_open_door_gearbox_torque_arr
  end

  def downhill_ht_upper_deviation_open_door_gearbox_torque_arr # 平坡高温上偏差开门减速箱扭矩
    downhill_ht_upper_deviation_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      downhill_ht_upper_deviation_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_upper_deviation_open_door_gearbox_torque_arr
  end

  def downhill_ht_after_life_open_door_gearbox_torque_arr # 平坡高温寿命后开门减速箱扭矩
    downhill_ht_after_life_open_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_open_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      downhill_ht_after_life_open_door_gearbox_torque_arr << (i + j - k * 0.96) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_after_life_open_door_gearbox_torque_arr
  end

  #  关门减速箱扭矩  #


  #  上坡

  def uphill_lt_lower_deviation_close_door_gearbox_torque_arr # 上坡低温下偏差关门减速箱扭矩
    uphill_lt_lower_deviation_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      uphill_lt_lower_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_lower_deviation_close_door_gearbox_torque_arr
  end

  def uphill_lt_median_close_door_gearbox_torque_arr # 上坡低温中值关门减速箱扭矩
    uphill_lt_median_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      uphill_lt_median_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_median_close_door_gearbox_torque_arr
  end

  def uphill_lt_upper_deviation_close_door_gearbox_torque_arr # 上坡低温上偏差关门减速箱扭矩
    uphill_lt_upper_deviation_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      uphill_lt_upper_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_upper_deviation_close_door_gearbox_torque_arr
  end

  def uphill_lt_after_life_close_door_gearbox_torque_arr # 上坡低温寿命后关门减速箱扭矩
    uphill_lt_after_life_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      uphill_lt_after_life_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_lt_after_life_close_door_gearbox_torque_arr
  end

  def uphill_nt_lower_deviation_close_door_gearbox_torque_arr # 上坡常温下偏差关门减速箱扭矩
    uphill_nt_lower_deviation_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      uphill_nt_lower_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_lower_deviation_close_door_gearbox_torque_arr
  end

  def uphill_nt_median_close_door_gearbox_torque_arr # 上坡常温中值关门减速箱扭矩
    uphill_nt_median_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      uphill_nt_median_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_median_close_door_gearbox_torque_arr
  end

  def uphill_nt_upper_deviation_close_door_gearbox_torque_arr # 上坡常温上偏差关门减速箱扭矩
    uphill_nt_upper_deviation_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      uphill_nt_upper_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_upper_deviation_close_door_gearbox_torque_arr
  end

  def uphill_nt_after_life_close_door_gearbox_torque_arr # 上坡常温寿命后关门减速箱扭矩
    uphill_nt_after_life_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      uphill_nt_after_life_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_nt_after_life_close_door_gearbox_torque_arr
  end

  def uphill_ht_lower_deviation_close_door_gearbox_torque_arr # 上坡高温下偏差关门减速箱扭矩
    uphill_ht_lower_deviation_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      uphill_ht_lower_deviation_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_lower_deviation_close_door_gearbox_torque_arr
  end

  def uphill_ht_median_close_door_gearbox_torque_arr # 上坡高温中值关门减速箱扭矩
    uphill_ht_median_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      uphill_ht_median_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_median_close_door_gearbox_torque_arr
  end

  def uphill_ht_upper_deviation_close_door_gearbox_torque_arr # 上坡高温上偏差关门减速箱扭矩
    uphill_ht_upper_deviation_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      uphill_ht_upper_deviation_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_upper_deviation_close_door_gearbox_torque_arr
  end

  def uphill_ht_after_life_close_door_gearbox_torque_arr # 上坡高温寿命后关门减速箱扭矩
    uphill_ht_after_life_close_door_gearbox_torque_arr = []
    uphill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      uphill_ht_after_life_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    uphill_ht_after_life_close_door_gearbox_torque_arr
  end

  # 平坡

  def flat_slope_lt_lower_deviation_close_door_gearbox_torque_arr # 平坡低温下偏差关门减速箱扭矩
    flat_slope_lt_lower_deviation_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      flat_slope_lt_lower_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_lower_deviation_close_door_gearbox_torque_arr
  end

  def flat_slope_lt_median_close_door_gearbox_torque_arr # 平坡低温中值关门减速箱扭矩
    flat_slope_lt_median_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      flat_slope_lt_median_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_median_close_door_gearbox_torque_arr
  end

  def flat_slope_lt_upper_deviation_close_door_gearbox_torque_arr # 平坡低温上偏差关门减速箱扭矩
    flat_slope_lt_upper_deviation_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      flat_slope_lt_upper_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_upper_deviation_close_door_gearbox_torque_arr
  end

  def flat_slope_lt_after_life_close_door_gearbox_torque_arr # 平坡低温寿命后关门减速箱扭矩
    flat_slope_lt_after_life_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      flat_slope_lt_after_life_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_lt_after_life_close_door_gearbox_torque_arr
  end

  def flat_slope_nt_lower_deviation_close_door_gearbox_torque_arr # 平坡常温下偏差关门减速箱扭矩
    flat_slope_nt_lower_deviation_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      flat_slope_nt_lower_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_lower_deviation_close_door_gearbox_torque_arr
  end

  def flat_slope_nt_median_close_door_gearbox_torque_arr # 平坡常温中值关门减速箱扭矩
    flat_slope_nt_median_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      flat_slope_nt_median_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_median_close_door_gearbox_torque_arr
  end

  def flat_slope_nt_upper_deviation_close_door_gearbox_torque_arr # 平坡常温上偏差关门减速箱扭矩
    flat_slope_nt_upper_deviation_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      flat_slope_nt_upper_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_upper_deviation_close_door_gearbox_torque_arr
  end

  def flat_slope_nt_after_life_close_door_gearbox_torque_arr # 平坡常温寿命后关门减速箱扭矩
    flat_slope_nt_after_life_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      flat_slope_nt_after_life_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_nt_after_life_close_door_gearbox_torque_arr
  end

  def flat_slope_ht_lower_deviation_close_door_gearbox_torque_arr # 平坡高温下偏差关门减速箱扭矩
    flat_slope_ht_lower_deviation_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      flat_slope_ht_lower_deviation_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_lower_deviation_close_door_gearbox_torque_arr
  end

  def flat_slope_ht_median_close_door_gearbox_torque_arr # 平坡高温中值关门减速箱扭矩
    flat_slope_ht_median_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      flat_slope_ht_median_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_median_close_door_gearbox_torque_arr
  end

  def flat_slope_ht_upper_deviation_close_door_gearbox_torque_arr # 平坡高温上偏差关门减速箱扭矩
    flat_slope_ht_upper_deviation_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      flat_slope_ht_upper_deviation_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_upper_deviation_close_door_gearbox_torque_arr
  end

  def flat_slope_ht_after_life_close_door_gearbox_torque_arr # 平坡高温寿命后关门减速箱扭矩
    flat_slope_ht_after_life_close_door_gearbox_torque_arr = []
    flat_slope_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      flat_slope_ht_after_life_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    flat_slope_ht_after_life_close_door_gearbox_torque_arr
  end

  # 下坡

  def downhill_lt_lower_deviation_close_door_gearbox_torque_arr # 下坡低温下偏差关门减速箱扭矩
    downhill_lt_lower_deviation_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      downhill_lt_lower_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_lower_deviation_close_door_gearbox_torque_arr
  end

  def downhill_lt_median_close_door_gearbox_torque_arr # 下坡低温中值关门减速箱扭矩
    downhill_lt_median_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      downhill_lt_median_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_median_close_door_gearbox_torque_arr
  end

  def downhill_lt_upper_deviation_close_door_gearbox_torque_arr # 下坡低温上偏差关门减速箱扭矩
    downhill_lt_upper_deviation_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      downhill_lt_upper_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_upper_deviation_close_door_gearbox_torque_arr
  end

  def downhill_lt_after_life_close_door_gearbox_torque_arr # 下坡低温寿命后关门减速箱扭矩
    downhill_lt_after_life_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(lt_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      downhill_lt_after_life_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_lt_after_life_close_door_gearbox_torque_arr
  end

  def downhill_nt_lower_deviation_close_door_gearbox_torque_arr # 下坡常温下偏差关门减速箱扭矩
    downhill_nt_lower_deviation_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      downhill_nt_lower_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_lower_deviation_close_door_gearbox_torque_arr
  end

  def downhill_nt_median_close_door_gearbox_torque_arr # 下坡常温中值关门减速箱扭矩
    downhill_nt_median_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      downhill_nt_median_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_median_close_door_gearbox_torque_arr
  end

  def downhill_nt_upper_deviation_close_door_gearbox_torque_arr # 下坡常温上偏差关门减速箱扭矩
    downhill_nt_upper_deviation_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      downhill_nt_upper_deviation_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_upper_deviation_close_door_gearbox_torque_arr
  end

  def downhill_nt_after_life_close_door_gearbox_torque_arr # 下坡常温寿命后关门减速箱扭矩
    downhill_nt_after_life_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(nt_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      downhill_nt_after_life_close_door_gearbox_torque_arr << (k - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_nt_after_life_close_door_gearbox_torque_arr
  end

  def downhill_ht_lower_deviation_close_door_gearbox_torque_arr # 下坡高温下偏差关门减速箱扭矩
    downhill_ht_lower_deviation_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_lower_deviation_spring_force_arr) do |i,j,k|
      downhill_ht_lower_deviation_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_lower_deviation_close_door_gearbox_torque_arr
  end

  def downhill_ht_median_close_door_gearbox_torque_arr # 下坡高温中值关门减速箱扭矩
    downhill_ht_median_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_spring_force_arr) do |i,j,k|
      downhill_ht_median_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_median_close_door_gearbox_torque_arr
  end

  def downhill_ht_upper_deviation_close_door_gearbox_torque_arr # 下坡高温上偏差关门减速箱扭矩
    downhill_ht_upper_deviation_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_upper_deviation_spring_force_arr) do |i,j,k|
      downhill_ht_upper_deviation_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_upper_deviation_close_door_gearbox_torque_arr
  end

  def downhill_ht_after_life_close_door_gearbox_torque_arr # 下坡高温寿命后关门减速箱扭矩
    downhill_ht_after_life_close_door_gearbox_torque_arr = []
    downhill_need_pole_thrust_force_arr.zip(ht_close_dynamic_friction_arr, nt_after_life_spring_force_arr) do |i,j,k|
      downhill_ht_after_life_close_door_gearbox_torque_arr << (k * 0.96 - i - j) * platform.lead / (2 * PI) / 1000
    end
    downhill_ht_after_life_close_door_gearbox_torque_arr
  end




  #  开门电机扭矩  #


  #  上坡

  def uphill_lt_lower_deviation_open_door_motor_torque_arr # 上坡低温下偏差开门电机扭矩
    uphill_lt_lower_deviation_open_door_motor_torque_arr = []
    uphill_lt_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      uphill_lt_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_lower_deviation_open_door_motor_torque_arr
  end

  def uphill_lt_median_open_door_motor_torque_arr # 上坡低温中值开门电机扭矩
    uphill_lt_median_open_door_motor_torque_arr = []
    uphill_lt_median_open_door_gearbox_torque_arr.each do |i|
      uphill_lt_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_median_open_door_motor_torque_arr
  end

  def uphill_lt_upper_deviation_open_door_motor_torque_arr # 上坡低温上偏差开门电机扭矩
    uphill_lt_upper_deviation_open_door_motor_torque_arr = []
    uphill_lt_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      uphill_lt_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_upper_deviation_open_door_motor_torque_arr
  end

  def uphill_lt_after_life_open_door_motor_torque_arr # 上坡低温寿命后开门电机扭矩
    uphill_lt_after_life_open_door_motor_torque_arr = []
    uphill_lt_after_life_open_door_gearbox_torque_arr.each do |i|
      uphill_lt_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_after_life_open_door_motor_torque_arr
  end

  def uphill_nt_lower_deviation_open_door_motor_torque_arr # 上坡常温下偏差开门电机扭矩
    uphill_nt_lower_deviation_open_door_motor_torque_arr = []
    uphill_nt_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      uphill_nt_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_lower_deviation_open_door_motor_torque_arr
  end

  def uphill_nt_median_open_door_motor_torque_arr # 上坡常温中值开门电机扭矩
    uphill_nt_median_open_door_motor_torque_arr = []
    uphill_nt_median_open_door_gearbox_torque_arr.each do |i|
      uphill_nt_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_median_open_door_motor_torque_arr
  end

  def uphill_nt_upper_deviation_open_door_motor_torque_arr # 上坡常温上偏差开门电机扭矩
    uphill_nt_upper_deviation_open_door_motor_torque_arr = []
    uphill_nt_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      uphill_nt_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_upper_deviation_open_door_motor_torque_arr
  end

  def uphill_nt_after_life_open_door_motor_torque_arr # 上坡常温寿命后开门电机扭矩
    uphill_nt_after_life_open_door_motor_torque_arr = []
    uphill_nt_after_life_open_door_gearbox_torque_arr.each do |i|
      uphill_nt_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_after_life_open_door_motor_torque_arr
  end

  def uphill_ht_lower_deviation_open_door_motor_torque_arr # 上坡高温下偏差开门电机扭矩
    uphill_ht_lower_deviation_open_door_motor_torque_arr = []
    uphill_ht_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      uphill_ht_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_lower_deviation_open_door_motor_torque_arr
  end

  def uphill_ht_median_open_door_motor_torque_arr # 上坡高温中值开门电机扭矩
    uphill_ht_median_open_door_motor_torque_arr = []
    uphill_ht_median_open_door_gearbox_torque_arr.each do |i|
      uphill_ht_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_median_open_door_motor_torque_arr
  end

  def uphill_ht_upper_deviation_open_door_motor_torque_arr # 上坡高温上偏差开门电机扭矩
    uphill_ht_upper_deviation_open_door_motor_torque_arr = []
    uphill_ht_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      uphill_ht_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_upper_deviation_open_door_motor_torque_arr
  end

  def uphill_ht_after_life_open_door_motor_torque_arr # 上坡高温寿命后开门电机扭矩
    uphill_ht_after_life_open_door_motor_torque_arr = []
    uphill_ht_after_life_open_door_gearbox_torque_arr.each do |i|
      uphill_ht_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_after_life_open_door_motor_torque_arr
  end

  # 平坡

  def flat_slope_lt_lower_deviation_open_door_motor_torque_arr # 平坡低温下偏差开门电机扭矩
    flat_slope_lt_lower_deviation_open_door_motor_torque_arr = []
    flat_slope_lt_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_lower_deviation_open_door_motor_torque_arr
  end

  def flat_slope_lt_median_open_door_motor_torque_arr # 平坡低温中值开门电机扭矩
    flat_slope_lt_median_open_door_motor_torque_arr = []
    flat_slope_lt_median_open_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_median_open_door_motor_torque_arr
  end

  def flat_slope_lt_upper_deviation_open_door_motor_torque_arr # 平坡低温上偏差开门电机扭矩
    flat_slope_lt_upper_deviation_open_door_motor_torque_arr = []
    flat_slope_lt_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_upper_deviation_open_door_motor_torque_arr
  end

  def flat_slope_lt_after_life_open_door_motor_torque_arr # 平坡低温寿命后开门电机扭矩
    flat_slope_lt_after_life_open_door_motor_torque_arr = []
    flat_slope_lt_after_life_open_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_after_life_open_door_motor_torque_arr
  end

  def flat_slope_nt_lower_deviation_open_door_motor_torque_arr # 平坡常温下偏差开门电机扭矩
    flat_slope_nt_lower_deviation_open_door_motor_torque_arr = []
    flat_slope_nt_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_lower_deviation_open_door_motor_torque_arr
  end

  def flat_slope_nt_median_open_door_motor_torque_arr # 平坡常温中值开门电机扭矩
    flat_slope_nt_median_open_door_motor_torque_arr = []
    flat_slope_nt_median_open_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_median_open_door_motor_torque_arr
  end

  def flat_slope_nt_upper_deviation_open_door_motor_torque_arr # 平坡常温上偏差开门电机扭矩
    flat_slope_nt_upper_deviation_open_door_motor_torque_arr = []
    flat_slope_nt_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_upper_deviation_open_door_motor_torque_arr
  end

  def flat_slope_nt_after_life_open_door_motor_torque_arr # 平坡常温寿命后开门电机扭矩
    flat_slope_nt_after_life_open_door_motor_torque_arr = []
    flat_slope_nt_after_life_open_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_after_life_open_door_motor_torque_arr
  end

  def flat_slope_ht_lower_deviation_open_door_motor_torque_arr # 平坡高温下偏差开门电机扭矩
    flat_slope_ht_lower_deviation_open_door_motor_torque_arr = []
    flat_slope_ht_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_lower_deviation_open_door_motor_torque_arr
  end

  def flat_slope_ht_median_open_door_motor_torque_arr # 平坡高温中值开门电机扭矩
    flat_slope_ht_median_open_door_motor_torque_arr = []
    flat_slope_ht_median_open_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_median_open_door_motor_torque_arr
  end

  def flat_slope_ht_upper_deviation_open_door_motor_torque_arr # 平坡高温上偏差开门电机扭矩
    flat_slope_ht_upper_deviation_open_door_motor_torque_arr = []
    flat_slope_ht_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_upper_deviation_open_door_motor_torque_arr
  end

  def flat_slope_ht_after_life_open_door_motor_torque_arr # 平坡高温寿命后开门电机扭矩
    flat_slope_ht_after_life_open_door_motor_torque_arr = []
    flat_slope_ht_after_life_open_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_after_life_open_door_motor_torque_arr
  end

  # 下坡

  def downhill_lt_lower_deviation_open_door_motor_torque_arr # 平坡低温下偏差开门电机扭矩
    downhill_lt_lower_deviation_open_door_motor_torque_arr = []
    downhill_lt_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      downhill_lt_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_lower_deviation_open_door_motor_torque_arr
  end

  def downhill_lt_median_open_door_motor_torque_arr # 平坡低温中值开门电机扭矩
    downhill_lt_median_open_door_motor_torque_arr = []
    downhill_lt_median_open_door_gearbox_torque_arr.each do |i|
      downhill_lt_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_median_open_door_motor_torque_arr
  end

  def downhill_lt_upper_deviation_open_door_motor_torque_arr # 平坡低温上偏差开门电机扭矩
    downhill_lt_upper_deviation_open_door_motor_torque_arr = []
    downhill_lt_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      downhill_lt_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_upper_deviation_open_door_motor_torque_arr
  end

  def downhill_lt_after_life_open_door_motor_torque_arr # 平坡低温寿命后开门电机扭矩
    downhill_lt_after_life_open_door_motor_torque_arr = []
    downhill_lt_after_life_open_door_gearbox_torque_arr.each do |i|
      downhill_lt_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_after_life_open_door_motor_torque_arr
  end

  def downhill_nt_lower_deviation_open_door_motor_torque_arr # 平坡常温下偏差开门电机扭矩
    downhill_nt_lower_deviation_open_door_motor_torque_arr = []
    downhill_nt_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      downhill_nt_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_lower_deviation_open_door_motor_torque_arr
  end

  def downhill_nt_median_open_door_motor_torque_arr # 平坡常温中值开门电机扭矩
    downhill_nt_median_open_door_motor_torque_arr = []
    downhill_nt_median_open_door_gearbox_torque_arr.each do |i|
      downhill_nt_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_median_open_door_motor_torque_arr
  end

  def downhill_nt_upper_deviation_open_door_motor_torque_arr # 平坡常温上偏差开门电机扭矩
    downhill_nt_upper_deviation_open_door_motor_torque_arr = []
    downhill_nt_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      downhill_nt_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_upper_deviation_open_door_motor_torque_arr
  end

  def downhill_nt_after_life_open_door_motor_torque_arr # 平坡常温寿命后开门电机扭矩
    downhill_nt_after_life_open_door_motor_torque_arr = []
    downhill_nt_after_life_open_door_gearbox_torque_arr.each do |i|
      downhill_nt_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_after_life_open_door_motor_torque_arr
  end

  def downhill_ht_lower_deviation_open_door_motor_torque_arr # 平坡高温下偏差开门电机扭矩
    downhill_ht_lower_deviation_open_door_motor_torque_arr = []
    downhill_ht_lower_deviation_open_door_gearbox_torque_arr.each do |i|
      downhill_ht_lower_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_lower_deviation_open_door_motor_torque_arr
  end

  def downhill_ht_median_open_door_motor_torque_arr # 平坡高温中值开门电机扭矩
    downhill_ht_median_open_door_motor_torque_arr = []
    downhill_ht_median_open_door_gearbox_torque_arr.each do |i|
      downhill_ht_median_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_median_open_door_motor_torque_arr
  end

  def downhill_ht_upper_deviation_open_door_motor_torque_arr # 平坡高温上偏差开门电机扭矩
    downhill_ht_upper_deviation_open_door_motor_torque_arr = []
    downhill_ht_upper_deviation_open_door_gearbox_torque_arr.each do |i|
      downhill_ht_upper_deviation_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_upper_deviation_open_door_motor_torque_arr
  end

  def downhill_ht_after_life_open_door_motor_torque_arr # 平坡高温寿命后开门电机扭矩
    downhill_ht_after_life_open_door_motor_torque_arr = []
    downhill_ht_after_life_open_door_gearbox_torque_arr.each do |i|
      downhill_ht_after_life_open_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_after_life_open_door_motor_torque_arr
  end

  #  关门电机扭矩  #


  #  上坡

  def uphill_lt_lower_deviation_close_door_motor_torque_arr # 上坡低温下偏差关门电机扭矩
    uphill_lt_lower_deviation_close_door_motor_torque_arr = []
    uphill_lt_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      uphill_lt_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_lower_deviation_close_door_motor_torque_arr
  end

  def uphill_lt_median_close_door_motor_torque_arr # 上坡低温中值关门电机扭矩
    uphill_lt_median_close_door_motor_torque_arr = []
    uphill_lt_median_close_door_gearbox_torque_arr.each do |i|
      uphill_lt_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_median_close_door_motor_torque_arr
  end

  def uphill_lt_upper_deviation_close_door_motor_torque_arr # 上坡低温上偏差关门电机扭矩
    uphill_lt_upper_deviation_close_door_motor_torque_arr = []
    uphill_lt_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      uphill_lt_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_upper_deviation_close_door_motor_torque_arr
  end

  def uphill_lt_after_life_close_door_motor_torque_arr # 上坡低温寿命后关门电机扭矩
    uphill_lt_after_life_close_door_motor_torque_arr = []
    uphill_lt_after_life_close_door_gearbox_torque_arr.each do |i|
      uphill_lt_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_lt_after_life_close_door_motor_torque_arr
  end

  def uphill_nt_lower_deviation_close_door_motor_torque_arr # 上坡常温下偏差关门电机扭矩
    uphill_nt_lower_deviation_close_door_motor_torque_arr = []
    uphill_nt_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      uphill_nt_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_lower_deviation_close_door_motor_torque_arr
  end

  def uphill_nt_median_close_door_motor_torque_arr # 上坡常温中值关门电机扭矩
    uphill_nt_median_close_door_motor_torque_arr = []
    uphill_nt_median_close_door_gearbox_torque_arr.each do |i|
      uphill_nt_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_median_close_door_motor_torque_arr
  end

  def uphill_nt_upper_deviation_close_door_motor_torque_arr # 上坡常温上偏差关门电机扭矩
    uphill_nt_upper_deviation_close_door_motor_torque_arr = []
    uphill_nt_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      uphill_nt_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_upper_deviation_close_door_motor_torque_arr
  end

  def uphill_nt_after_life_close_door_motor_torque_arr # 上坡常温寿命后关门电机扭矩
    uphill_nt_after_life_close_door_motor_torque_arr = []
    uphill_nt_after_life_close_door_gearbox_torque_arr.each do |i|
      uphill_nt_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_nt_after_life_close_door_motor_torque_arr
  end

  def uphill_ht_lower_deviation_close_door_motor_torque_arr # 上坡高温下偏差关门电机扭矩
    uphill_ht_lower_deviation_close_door_motor_torque_arr = []
    uphill_ht_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      uphill_ht_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_lower_deviation_close_door_motor_torque_arr
  end

  def uphill_ht_median_close_door_motor_torque_arr # 上坡高温中值关门电机扭矩
    uphill_ht_median_close_door_motor_torque_arr = []
    uphill_ht_median_close_door_gearbox_torque_arr.each do |i|
      uphill_ht_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_median_close_door_motor_torque_arr
  end

  def uphill_ht_upper_deviation_close_door_motor_torque_arr # 上坡高温上偏差关门电机扭矩
    uphill_ht_upper_deviation_close_door_motor_torque_arr = []
    uphill_ht_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      uphill_ht_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_upper_deviation_close_door_motor_torque_arr
  end

  def uphill_ht_after_life_close_door_motor_torque_arr # 上坡高温寿命后关门电机扭矩
    uphill_ht_after_life_close_door_motor_torque_arr = []
    uphill_ht_after_life_close_door_gearbox_torque_arr.each do |i|
      uphill_ht_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    uphill_ht_after_life_close_door_motor_torque_arr
  end

  # 平坡

  def flat_slope_lt_lower_deviation_close_door_motor_torque_arr # 平坡低温下偏差关门电机扭矩
    flat_slope_lt_lower_deviation_close_door_motor_torque_arr = []
    flat_slope_lt_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_lower_deviation_close_door_motor_torque_arr
  end

  def flat_slope_lt_median_close_door_motor_torque_arr # 平坡低温中值关门电机扭矩
    flat_slope_lt_median_close_door_motor_torque_arr = []
    flat_slope_lt_median_close_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_median_close_door_motor_torque_arr
  end

  def flat_slope_lt_upper_deviation_close_door_motor_torque_arr # 平坡低温上偏差关门电机扭矩
    flat_slope_lt_upper_deviation_close_door_motor_torque_arr = []
    flat_slope_lt_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_upper_deviation_close_door_motor_torque_arr
  end

  def flat_slope_lt_after_life_close_door_motor_torque_arr # 平坡低温寿命后关门电机扭矩
    flat_slope_lt_after_life_close_door_motor_torque_arr = []
    flat_slope_lt_after_life_close_door_gearbox_torque_arr.each do |i|
      flat_slope_lt_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_lt_after_life_close_door_motor_torque_arr
  end

  def flat_slope_nt_lower_deviation_close_door_motor_torque_arr # 平坡常温下偏差关门电机扭矩
    flat_slope_nt_lower_deviation_close_door_motor_torque_arr = []
    flat_slope_nt_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_lower_deviation_close_door_motor_torque_arr
  end

  def flat_slope_nt_median_close_door_motor_torque_arr # 平坡常温中值关门电机扭矩
    flat_slope_nt_median_close_door_motor_torque_arr = []
    flat_slope_nt_median_close_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_median_close_door_motor_torque_arr
  end

  def flat_slope_nt_upper_deviation_close_door_motor_torque_arr # 平坡常温上偏差关门电机扭矩
    flat_slope_nt_upper_deviation_close_door_motor_torque_arr = []
    flat_slope_nt_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_upper_deviation_close_door_motor_torque_arr
  end

  def flat_slope_nt_after_life_close_door_motor_torque_arr # 平坡常温寿命后关门电机扭矩
    flat_slope_nt_after_life_close_door_motor_torque_arr = []
    flat_slope_nt_after_life_close_door_gearbox_torque_arr.each do |i|
      flat_slope_nt_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_nt_after_life_close_door_motor_torque_arr
  end

  def flat_slope_ht_lower_deviation_close_door_motor_torque_arr # 平坡高温下偏差关门电机扭矩
    flat_slope_ht_lower_deviation_close_door_motor_torque_arr = []
    flat_slope_ht_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_lower_deviation_close_door_motor_torque_arr
  end

  def flat_slope_ht_median_close_door_motor_torque_arr # 平坡高温中值关门电机扭矩
    flat_slope_ht_median_close_door_motor_torque_arr = []
    flat_slope_ht_median_close_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_median_close_door_motor_torque_arr
  end

  def flat_slope_ht_upper_deviation_close_door_motor_torque_arr # 平坡高温上偏差关门电机扭矩
    flat_slope_ht_upper_deviation_close_door_motor_torque_arr = []
    flat_slope_ht_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_upper_deviation_close_door_motor_torque_arr
  end

  def flat_slope_ht_after_life_close_door_motor_torque_arr # 平坡高温寿命后关门电机扭矩
    flat_slope_ht_after_life_close_door_motor_torque_arr = []
    flat_slope_ht_after_life_close_door_gearbox_torque_arr.each do |i|
      flat_slope_ht_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    flat_slope_ht_after_life_close_door_motor_torque_arr
  end

  # 下坡

  def downhill_lt_lower_deviation_close_door_motor_torque_arr # 下坡低温下偏差关门电机扭矩
    downhill_lt_lower_deviation_close_door_motor_torque_arr = []
    downhill_lt_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      downhill_lt_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_lower_deviation_close_door_motor_torque_arr
  end

  def downhill_lt_median_close_door_motor_torque_arr # 下坡低温中值关门电机扭矩
    downhill_lt_median_close_door_motor_torque_arr = []
    downhill_lt_median_close_door_gearbox_torque_arr.each do |i|
      downhill_lt_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_median_close_door_motor_torque_arr
  end

  def downhill_lt_upper_deviation_close_door_motor_torque_arr # 下坡低温上偏差关门电机扭矩
    downhill_lt_upper_deviation_close_door_motor_torque_arr = []
    downhill_lt_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      downhill_lt_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_upper_deviation_close_door_motor_torque_arr
  end

  def downhill_lt_after_life_close_door_motor_torque_arr # 下坡低温寿命后关门电机扭矩
    downhill_lt_after_life_close_door_motor_torque_arr = []
    downhill_lt_after_life_close_door_gearbox_torque_arr.each do |i|
      downhill_lt_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_lt_after_life_close_door_motor_torque_arr
  end

  def downhill_nt_lower_deviation_close_door_motor_torque_arr # 下坡常温下偏差关门电机扭矩
    downhill_nt_lower_deviation_close_door_motor_torque_arr = []
    downhill_nt_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      downhill_nt_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_lower_deviation_close_door_motor_torque_arr
  end

  def downhill_nt_median_close_door_motor_torque_arr # 下坡常温中值关门电机扭矩
    downhill_nt_median_close_door_motor_torque_arr = []
    downhill_nt_median_close_door_gearbox_torque_arr.each do |i|
      downhill_nt_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_median_close_door_motor_torque_arr
  end

  def downhill_nt_upper_deviation_close_door_motor_torque_arr # 下坡常温上偏差关门电机扭矩
    downhill_nt_upper_deviation_close_door_motor_torque_arr = []
    downhill_nt_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      downhill_nt_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_upper_deviation_close_door_motor_torque_arr
  end

  def downhill_nt_after_life_close_door_motor_torque_arr # 下坡常温寿命后关门电机扭矩
    downhill_nt_after_life_close_door_motor_torque_arr = []
    downhill_nt_after_life_close_door_gearbox_torque_arr.each do |i|
      downhill_nt_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_nt_after_life_close_door_motor_torque_arr
  end

  def downhill_ht_lower_deviation_close_door_motor_torque_arr # 下坡高温下偏差关门电机扭矩
    downhill_ht_lower_deviation_close_door_motor_torque_arr = []
    downhill_ht_lower_deviation_close_door_gearbox_torque_arr.each do |i|
      downhill_ht_lower_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_lower_deviation_close_door_motor_torque_arr
  end

  def downhill_ht_median_close_door_motor_torque_arr # 下坡高温中值关门电机扭矩
    downhill_ht_median_close_door_motor_torque_arr = []
    downhill_ht_median_close_door_gearbox_torque_arr.each do |i|
      downhill_ht_median_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_median_close_door_motor_torque_arr
  end

  def downhill_ht_upper_deviation_close_door_motor_torque_arr # 下坡高温上偏差关门电机扭矩
    downhill_ht_upper_deviation_close_door_motor_torque_arr = []
    downhill_ht_upper_deviation_close_door_gearbox_torque_arr.each do |i|
      downhill_ht_upper_deviation_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_upper_deviation_close_door_motor_torque_arr
  end

  def downhill_ht_after_life_close_door_motor_torque_arr # 下坡高温寿命后关门电机扭矩
    downhill_ht_after_life_close_door_motor_torque_arr = []
    downhill_ht_after_life_close_door_gearbox_torque_arr.each do |i|
      downhill_ht_after_life_close_door_motor_torque_arr << i / platform.gear_transmission_ratio * 1000
    end
    downhill_ht_after_life_close_door_motor_torque_arr
  end

  #  开门电流    #

  # 上坡

  def uphill_lt_lower_deviation_open_door_current_arr  # 上坡低温下偏差开门电流
    uphill_lt_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_lower_deviation_open_door_current_arr
  end

  def uphill_lt_median_open_door_current_arr  # 上坡低温中值开门电流
    uphill_lt_median_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_median_open_door_current_arr
  end

  def uphill_lt_upper_deviation_open_door_current_arr  # 上坡低温上偏差开门电流
    uphill_lt_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_upper_deviation_open_door_current_arr
  end

  def uphill_lt_after_life_open_door_current_arr  # 上坡低温寿命后开门电流
    uphill_lt_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_after_life_open_door_current_arr
  end


  def uphill_nt_lower_deviation_open_door_current_arr  # 上坡常温下偏差开门电流
    uphill_nt_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_lower_deviation_open_door_current_arr
  end

  def uphill_nt_median_open_door_current_arr  # 上坡常温中值开门电流
    uphill_nt_median_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_median_open_door_current_arr
  end

  def uphill_nt_upper_deviation_open_door_current_arr  # 上坡常温上偏差开门电流
    uphill_nt_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_upper_deviation_open_door_current_arr
  end

  def uphill_nt_after_life_open_door_current_arr  # 上坡常温寿命后开门电流
    uphill_nt_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_after_life_open_door_current_arr
  end


  def uphill_ht_lower_deviation_open_door_current_arr  # 上坡高温下偏差开门电流
    uphill_ht_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_lower_deviation_open_door_current_arr
  end

  def uphill_ht_median_open_door_current_arr  # 上坡高温中值开门电流
    uphill_ht_median_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_median_open_door_current_arr
  end

  def uphill_ht_upper_deviation_open_door_current_arr  # 上坡高温上偏差开门电流
    uphill_ht_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_upper_deviation_open_door_current_arr
  end

  def uphill_ht_after_life_open_door_current_arr  # 上坡高温寿命后开门电流
    uphill_ht_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_after_life_open_door_current_arr
  end

  # 平坡

  def flat_slope_lt_lower_deviation_open_door_current_arr  # 平坡低温下偏差开门电流
    flat_slope_lt_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_lower_deviation_open_door_current_arr
  end

  def flat_slope_lt_median_open_door_current_arr  # 平坡低温中值开门电流
    flat_slope_lt_median_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_median_open_door_current_arr
  end

  def flat_slope_lt_upper_deviation_open_door_current_arr  # 平坡低温上偏差开门电流
    flat_slope_lt_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_upper_deviation_open_door_current_arr
  end

  def flat_slope_lt_after_life_open_door_current_arr  # 平坡低温寿命后开门电流
    flat_slope_lt_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_after_life_open_door_current_arr
  end


  def flat_slope_nt_lower_deviation_open_door_current_arr  # 平坡常温下偏差开门电流
    flat_slope_nt_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_lower_deviation_open_door_current_arr
  end

  def flat_slope_nt_median_open_door_current_arr  # 平坡常温中值开门电流
    flat_slope_nt_median_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_median_open_door_current_arr
  end

  def flat_slope_nt_upper_deviation_open_door_current_arr  # 平坡常温上偏差开门电流
    flat_slope_nt_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_upper_deviation_open_door_current_arr
  end

  def flat_slope_nt_after_life_open_door_current_arr  # 平坡常温寿命后开门电流
    flat_slope_nt_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_after_life_open_door_current_arr
  end


  def flat_slope_ht_lower_deviation_open_door_current_arr  # 平坡高温下偏差开门电流
    flat_slope_ht_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_lower_deviation_open_door_current_arr
  end

  def flat_slope_ht_median_open_door_current_arr  # 平坡高温中值开门电流
    flat_slope_ht_median_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_median_open_door_current_arr
  end

  def flat_slope_ht_upper_deviation_open_door_current_arr  # 平坡高温上偏差开门电流
    flat_slope_ht_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_upper_deviation_open_door_current_arr
  end

  def flat_slope_ht_after_life_open_door_current_arr  # 平坡高温寿命后开门电流
    flat_slope_ht_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_after_life_open_door_current_arr
  end

  # 下坡

  def downhill_lt_lower_deviation_open_door_current_arr  # 下坡低温下偏差开门电流
    downhill_lt_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_lower_deviation_open_door_current_arr
  end

  def downhill_lt_median_open_door_current_arr  # 下坡低温中值开门电流
    downhill_lt_median_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_median_open_door_current_arr
  end

  def downhill_lt_upper_deviation_open_door_current_arr  # 下坡低温上偏差开门电流
    downhill_lt_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_upper_deviation_open_door_current_arr
  end

  def downhill_lt_after_life_open_door_current_arr  # 下坡低温寿命后开门电流
    downhill_lt_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_after_life_open_door_current_arr
  end


  def downhill_nt_lower_deviation_open_door_current_arr  # 下坡常温下偏差开门电流
    downhill_nt_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_lower_deviation_open_door_current_arr
  end

  def downhill_nt_median_open_door_current_arr  # 下坡常温中值开门电流
    downhill_nt_median_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_median_open_door_current_arr
  end

  def downhill_nt_upper_deviation_open_door_current_arr  # 下坡常温上偏差开门电流
    downhill_nt_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_upper_deviation_open_door_current_arr
  end

  def downhill_nt_after_life_open_door_current_arr  # 下坡常温寿命后开门电流
    downhill_nt_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_after_life_open_door_current_arr
  end


  def downhill_ht_lower_deviation_open_door_current_arr  # 下坡高温下偏差开门电流
    downhill_ht_lower_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_lower_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_lower_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_lower_deviation_open_door_current_arr
  end

  def downhill_ht_median_open_door_current_arr  # 下坡高温中值开门电流
    downhill_ht_median_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_median_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_median_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_median_open_door_current_arr
  end

  def downhill_ht_upper_deviation_open_door_current_arr  # 下坡高温上偏差开门电流
    downhill_ht_upper_deviation_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_upper_deviation_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_upper_deviation_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_upper_deviation_open_door_current_arr
  end

  def downhill_ht_after_life_open_door_current_arr  # 下坡高温寿命后开门电流
    downhill_ht_after_life_open_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_after_life_open_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_after_life_open_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_after_life_open_door_current_arr
  end

  #  关门电流    #

  # 上坡

  def uphill_lt_lower_deviation_close_door_current_arr  # 上坡低温下偏差关门电流
    uphill_lt_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_lower_deviation_close_door_current_arr
  end

  def uphill_lt_median_close_door_current_arr  # 上坡低温中值关门电流
    uphill_lt_median_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_median_close_door_current_arr
  end

  def uphill_lt_upper_deviation_close_door_current_arr  # 上坡低温上偏差关门电流
    uphill_lt_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_upper_deviation_close_door_current_arr
  end

  def uphill_lt_after_life_close_door_current_arr  # 上坡低温寿命后关门电流
    uphill_lt_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_lt_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_lt_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_lt_after_life_close_door_current_arr
  end


  def uphill_nt_lower_deviation_close_door_current_arr  # 上坡常温下偏差关门电流
    uphill_nt_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_lower_deviation_close_door_current_arr
  end

  def uphill_nt_median_close_door_current_arr  # 上坡常温中值关门电流
    uphill_nt_median_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_median_close_door_current_arr
  end

  def uphill_nt_upper_deviation_close_door_current_arr  # 上坡常温上偏差关门电流
    uphill_nt_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_upper_deviation_close_door_current_arr
  end

  def uphill_nt_after_life_close_door_current_arr  # 上坡常温寿命后关门电流
    uphill_nt_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_nt_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_nt_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_nt_after_life_close_door_current_arr
  end


  def uphill_ht_lower_deviation_close_door_current_arr  # 上坡高温下偏差关门电流
    uphill_ht_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_lower_deviation_close_door_current_arr
  end

  def uphill_ht_median_close_door_current_arr  # 上坡高温中值关门电流
    uphill_ht_median_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_median_close_door_current_arr
  end

  def uphill_ht_upper_deviation_close_door_current_arr  # 上坡高温上偏差关门电流
    uphill_ht_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_upper_deviation_close_door_current_arr
  end

  def uphill_ht_after_life_close_door_current_arr  # 上坡高温寿命后关门电流
    uphill_ht_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(uphill_ht_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      uphill_ht_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    uphill_ht_after_life_close_door_current_arr
  end

  # 平坡

  def flat_slope_lt_lower_deviation_close_door_current_arr  # 平坡低温下偏差关门电流
    flat_slope_lt_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_lower_deviation_close_door_current_arr
  end

  def flat_slope_lt_median_close_door_current_arr  # 平坡低温中值关门电流
    flat_slope_lt_median_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_median_close_door_current_arr
  end

  def flat_slope_lt_upper_deviation_close_door_current_arr  # 平坡低温上偏差关门电流
    flat_slope_lt_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_upper_deviation_close_door_current_arr
  end

  def flat_slope_lt_after_life_close_door_current_arr  # 平坡低温寿命后关门电流
    flat_slope_lt_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_lt_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_lt_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_lt_after_life_close_door_current_arr
  end


  def flat_slope_nt_lower_deviation_close_door_current_arr  # 平坡常温下偏差关门电流
    flat_slope_nt_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_lower_deviation_close_door_current_arr
  end

  def flat_slope_nt_median_close_door_current_arr  # 平坡常温中值关门电流
    flat_slope_nt_median_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_median_close_door_current_arr
  end

  def flat_slope_nt_upper_deviation_close_door_current_arr  # 平坡常温上偏差关门电流
    flat_slope_nt_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_upper_deviation_close_door_current_arr
  end

  def flat_slope_nt_after_life_close_door_current_arr  # 平坡常温寿命后关门电流
    flat_slope_nt_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_nt_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_nt_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_nt_after_life_close_door_current_arr
  end


  def flat_slope_ht_lower_deviation_close_door_current_arr  # 平坡高温下偏差关门电流
    flat_slope_ht_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_lower_deviation_close_door_current_arr
  end

  def flat_slope_ht_median_close_door_current_arr  # 平坡高温中值关门电流
    flat_slope_ht_median_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_median_close_door_current_arr
  end

  def flat_slope_ht_upper_deviation_close_door_current_arr  # 平坡高温上偏差关门电流
    flat_slope_ht_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_upper_deviation_close_door_current_arr
  end

  def flat_slope_ht_after_life_close_door_current_arr  # 平坡高温寿命后关门电流
    flat_slope_ht_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(flat_slope_ht_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      flat_slope_ht_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    flat_slope_ht_after_life_close_door_current_arr
  end

  # 下坡

  def downhill_lt_lower_deviation_close_door_current_arr  # 下坡低温下偏差关门电流
    downhill_lt_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_lower_deviation_close_door_current_arr
  end

  def downhill_lt_median_close_door_current_arr  # 下坡低温中值关门电流
    downhill_lt_median_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_median_close_door_current_arr
  end

  def downhill_lt_upper_deviation_close_door_current_arr  # 下坡低温上偏差关门电流
    downhill_lt_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_upper_deviation_close_door_current_arr
  end

  def downhill_lt_after_life_close_door_current_arr  # 下坡低温寿命后关门电流
    downhill_lt_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_lt_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_lt_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_lt_after_life_close_door_current_arr
  end


  def downhill_nt_lower_deviation_close_door_current_arr  # 下坡常温下偏差关门电流
    downhill_nt_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_lower_deviation_close_door_current_arr
  end

  def downhill_nt_median_close_door_current_arr  # 下坡常温中值关门电流
    downhill_nt_median_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_median_close_door_current_arr
  end

  def downhill_nt_upper_deviation_close_door_current_arr  # 下坡常温上偏差关门电流
    downhill_nt_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_upper_deviation_close_door_current_arr
  end

  def downhill_nt_after_life_close_door_current_arr  # 下坡常温寿命后关门电流
    downhill_nt_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_nt_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_nt_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_nt_after_life_close_door_current_arr
  end


  def downhill_ht_lower_deviation_close_door_current_arr  # 下坡高温下偏差关门电流
    downhill_ht_lower_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_lower_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_lower_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_lower_deviation_close_door_current_arr
  end

  def downhill_ht_median_close_door_current_arr  # 下坡高温中值关门电流
    downhill_ht_median_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_median_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_median_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_median_close_door_current_arr
  end

  def downhill_ht_upper_deviation_close_door_current_arr  # 下坡高温上偏差关门电流
    downhill_ht_upper_deviation_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_upper_deviation_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_upper_deviation_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_upper_deviation_close_door_current_arr
  end

  def downhill_ht_after_life_close_door_current_arr  # 下坡高温寿命后关门电流
    downhill_ht_after_life_close_door_current_arr = []
    motor_output_speed_arr.zip(downhill_ht_after_life_close_door_motor_torque_arr, motor_pwm_arr) do |i,j,k|
      downhill_ht_after_life_close_door_current_arr << i * j / (9550 * k * platform.rated_voltage * platform.motor_efficiency)
    end
    downhill_ht_after_life_close_door_current_arr
  end

  #  图表  #

  def bg_colors
    bg_colors = ['rgba(255, 99, 132, 0.2)',
                 'rgba(54, 162, 235, 0.2)',
                 'rgba(255, 206, 86, 0.2)',
                 'rgba(75, 192, 192, 0.2)',
                 'rgba(153, 102, 255, 0.2)',
                 'rgba(255, 159, 64, 0.2)'
                ]
  end
  def bd_colors
    bd_colors = [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)',
                'rgba(51,51,51,51)'
                ]
  end

  def lt_hover_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_lt_median_hover_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_upper_deviation_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_after_life_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_lt_median_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_upper_deviation_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_after_life_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_lt_median_hover_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_upper_deviation_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_after_life_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '开门内阻',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: lt_open_static_friction_arr,
            backgroundColor: bd_colors[6],
            borderColor: bd_colors[6],
            borderWidth: 1.5,

          },{
            label: '关门内阻',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: lt_close_static_friction_arr,
            backgroundColor: bd_colors[6],
            borderColor: bd_colors[6],
            borderWidth: 2,

          }]
    }
  end

  def nt_hover_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_lt_median_hover_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_upper_deviation_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_after_life_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_lt_median_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_upper_deviation_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_after_life_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_lt_median_hover_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_upper_deviation_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_after_life_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '开门内阻',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: nt_open_static_friction_arr,
            backgroundColor: bd_colors[6],
            borderColor: bd_colors[6],
            borderWidth: 1.5,
          },{
            label: '关门内阻',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: nt_close_static_friction_arr,
            backgroundColor: bd_colors[6],
            borderColor: bd_colors[6],
            borderWidth: 2,

          }]
    }
  end

  def ht_hover_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_ht_median_hover_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_upper_deviation_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_after_life_hover_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_ht_median_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_upper_deviation_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_after_life_hover_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_lower_deviation_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_ht_median_hover_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_upper_deviation_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_after_life_hover_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '开门内阻',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: ht_open_static_friction_arr,
            backgroundColor: bd_colors[6],
            borderColor: bd_colors[6],
            borderWidth: 1.5,
          },{
            label: '关门内阻',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: ht_close_static_friction_arr,
            backgroundColor: bd_colors[6],
            borderColor: bd_colors[6],
            borderWidth: 2,

          }]
    }
  end

# 手动开门力

  def lt_manually_open_door_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_lt_median_manually_open_door_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_upper_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_after_life_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_lt_median_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_upper_deviation_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_after_life_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_lt_median_manually_open_door_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_upper_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_after_life_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          }]
    }
  end

  def nt_manually_open_door_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_nt_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_nt_median_manually_open_door_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_nt_upper_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_nt_after_life_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_nt_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_nt_median_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_nt_upper_deviation_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_nt_after_life_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_nt_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_nt_median_manually_open_door_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_nt_upper_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_nt_after_life_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],

          }]
    }
  end

  def ht_manually_open_door_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_ht_median_manually_open_door_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_upper_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_after_life_manually_open_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_ht_median_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_upper_deviation_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_after_life_manually_open_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_lower_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_ht_median_manually_open_door_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_upper_deviation_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_after_life_manually_open_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          }]
    }
  end



  # 手动关门力

  def lt_manually_close_door_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_lt_median_manually_close_door_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_upper_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_lt_after_life_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_lt_median_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_upper_deviation_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_lt_after_life_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡低温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡低温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_lt_median_manually_close_door_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡低温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_upper_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡低温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_lt_after_life_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          }]
    }
  end

  def nt_manually_close_door_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_nt_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_nt_median_manually_close_door_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_nt_upper_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_nt_after_life_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_nt_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_nt_median_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_nt_upper_deviation_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_nt_after_life_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡常温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_nt_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡常温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_nt_median_manually_close_door_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡常温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_nt_upper_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡常温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_nt_after_life_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],

          }]
    }
  end

  def ht_manually_close_door_chart
    @data1 = {
        labels: open_angle_arr,
        datasets: [{
            label: '上坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '上坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: uphill_ht_median_manually_close_door_arr,
            backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
          },{
            label: '上坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_upper_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '上坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: uphill_ht_after_life_manually_close_door_arr,
            # backgroundColor: bd_colors[1],
            borderColor: bd_colors[1],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '平坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [10, 5],

          },{
            label: '平坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: flat_slope_ht_median_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
          },{
            label: '平坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_upper_deviation_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '平坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: flat_slope_ht_after_life_manually_close_door_arr,
            backgroundColor: bd_colors[3],
            borderColor: bd_colors[3],
            borderWidth: 2,
            borderDash: [2, 3],
          },{
            label: '下坡高温下偏差',
            fill: false, # 取消这行将填充面积
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_lower_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [10, 5],
          },{
            label: '下坡高温中值',
            fill: false,
            pointRadius: 1,
            pointHoverRadius: 3,
            data: downhill_ht_median_manually_close_door_arr,
            backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
          },{
            label: '下坡高温上偏差',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_upper_deviation_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 1.5,
            borderDash: [4, 5],
          },{
            label: '下坡高温寿命后',
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 3,
            data: downhill_ht_after_life_manually_close_door_arr,
            # backgroundColor: bd_colors[0],
            borderColor: bd_colors[0],
            borderWidth: 2,
            borderDash: [2, 3],
          }]
    }
  end


  protected

  def should_validate_basic_data?
    current_step == 1 # 只有做到第一步需要验证
  end

  def should_validate_all_data?
    current_step == 2   # 做到第二步时需要验证
  end



end
