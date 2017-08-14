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
  validates :active_coil_num, presence:  { message: "请填写弹簧线径" }, :if => :should_validate_all_data?




  belongs_to :platform
  # belongs_to :platform, inverse_of: :manual_calculations
  # 报错时考虑用
  # belongs_to :user

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

  def vector_ob_slope # 向量ob的斜率
    (gate_b_z - hinge_z) / (gate_b_x - hinge_x)
  end

  def vector_ab_slope # 向量ab的斜率
    (gate_b_z - body_a_z) / (gate_b_x - body_a_x)
  end

  def vector_ob_ab_angle # 向量OB和向量AB的夹角
    (180/PI) * atan((vector_ab_slope - vector_ob_slope) / (1 + vector_ab_slope * vector_ob_slope))
  end


  protected

  def should_validate_basic_data?
    current_step == 1 # 只有做到第一步需要验证
  end

  def should_validate_all_data?
    current_step == 2   # 做到第二步时需要验证
  end

end
