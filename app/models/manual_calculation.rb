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

  platform = Platform.find(2)
  def inside_diameter
    platform.inside_diameter
  end

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

  def hige_temperature_spring_rate # 高温弹簧刚度
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


  protected

  def should_validate_basic_data?
    current_step == 1 # 只有做到第一步需要验证
  end

  def should_validate_all_data?
    current_step == 2   # 做到第二步时需要验证
  end

end
