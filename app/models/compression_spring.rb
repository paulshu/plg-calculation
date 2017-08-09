class CompressionSpring < ApplicationRecord

  attr_accessor :current_step
  validates :product_name, presence:  { message: "请填写产品名称" }, :if => :should_validate_basic_data?
  validates :product_number,  presence:  { message: "请填写产品编号" },
                              uniqueness: { message: "产品编号重复了" } ,
                              if:  :should_validate_basic_data? # 表达方式不同而以
  validates :max_force, presence:  { message: "请填写弹簧最大负荷" }#, :if => :should_validate_basic_data?
  validates :min_force, presence:  { message: "请填写弹簧最小负荷" },
                        numericality:  { less_than: :max_force, message: "必须小于最大负荷" },
                        :if => :should_validate_basic_data?
  validates :min_force, numericality:  { greater_than: 0, message: "弹簧最小负荷必须大于0" }, :if => :should_validate_basic_data?
  validates :od_length, presence:  { message: "请填写弹簧开门长度" }, :if => :should_validate_basic_data?
  validates :cd_length, presence:  { message: "请填写弹簧关门长度" },
                        numericality:  { less_than: :od_length, message: "弹簧关门长度必须小于弹簧开门长度" },
                        :if => :should_validate_basic_data?
  validates :cd_length, numericality:  { greater_than: 0, message: "弹簧关门长度必须大于0" }, :if => :should_validate_basic_data?
  validates :active_coil_num, numericality:  { greater_than: 0, message: "弹簧有效圈数必须大于0" }, :if => :should_validate_all_data?
  validates :free_length, numericality:  { greater_than: 0, message: "弹簧自由长度必须大于0" }, :if => :should_validate_all_data?
  # validates :flocking, inclusion: { :in => ["植绒", "不植绒"]}, :if => :should_validate_all_data?
  # validates_inclusion_of :flocking, :in => ["植绒", "不植绒"], :if => :should_validate_all_data?
  # :if 这个参数可以设定调用那一个方法来决定要不要启用这个验证，回传 true 就是要，回传 false 就是不要
  # 透过 attr_accessor :current_step 我们增加一个虚拟属性(也就是数据库中并没有这个字段)来代表目前做到哪一步, 并定义相关函数，且在controller中更新步骤。



  def total_num?
    if self.active_coil_num.present?
      self.total_num = self.active_coil_num + 2
      self.update_columns(total_num: total_num)
    end
  end

  def od_force?
    if self.active_coil_num.present? && self.free_length.present?
      self.od_force = (free_length - od_length) * spring_rate
    else
      self.od_force = 0
    end
    self.update_columns(od_force: od_force)
  end

  def cd_force?
    if self.active_coil_num.present? && self.free_length.present?
      self.cd_force = (free_length - cd_length) * spring_rate
    else
      self.cd_force = 0
    end
    self.update_columns(cd_force: cd_force)
  end

  # 以下为通用的弹簧参数
  Initial_wire_diameter = 3.8 # 初选线径
  
  def deformation # 变形量
    deformation = od_length - cd_length
  end

  def max_test_shear_stress # 最大试验切应用力
    max_test_shear_stress = max_tensile_strength * 0.6
  end

  def dynamic_load_allowable_shear_stress # 动负荷许用切应力
    dynamic_load_allowable_shear_stress = max_tensile_strength * 0.57
  end

  def initial_mean_diameter #弹簧初选中径
    initial_mean_diameter = inside_diameter + Initial_wire_diameter
  end

  def mean_diameter # 弹簧中径
    mean_diameter = inside_diameter + wire_diameter
  end

  # 以下为helper调用的一些变量
  def spring_theoretical_rate # 理论刚度
    spring_theoretical_rate = (max_force - min_force) / deformation
  end

  def theoretical_wire_diameter # 理论线径
    c = initial_mean_diameter / Initial_wire_diameter
    k = (4*c-1)/(4*c-4) + (0.615/c)
    theoretical_wire_diameter = (8 * k * initial_mean_diameter * max_force / (PI * dynamic_load_allowable_shear_stress)) ** (1.0/3)
  end

  def theoretical_active_coil_num # 理论有效圈数
    theoretical_active_coil_num = (s_elastic_modulus * (wire_diameter ** (4))) / (8 * (mean_diameter ** (3)) * spring_theoretical_rate)
  end

  def no_solid_position_active_coil_num # 不压并建议有效圈数
    no_solid_position_active_coil_num = (cd_length - 13) / (wire_diameter + flocking.to_f) - 2
  end

  def spring_rate # 实际刚度
    if self.active_coil_num.present?
      spring_rate = s_elastic_modulus * (wire_diameter ** (4)) / (8 * (mean_diameter ** (3)) * active_coil_num )
    end
  end

  def theoretical_free_length # 理论自由长度
    if self.spring_rate.present?
      f1 = min_force / spring_rate
      f2 = max_force / spring_rate
      theoretical_free_length = [(od_length + f1), (cd_length + f2)].min
    else
      0
    end
  end

  def safe_spring_solid_position #安全压并高度
    if self.active_coil_num.present? && active_coil_num > 0 &&  self.total_num.present?
      safe_spring_solid_position = (wire_diameter + flocking.to_f) * total_num + 13
    else
      0
    end
  end

  def spring_solid_position_check # 弹簧压并校核
    if self.free_length.present? && self.active_coil_num.present? && active_coil_num > 0
      if safe_spring_solid_position <= cd_length && safe_spring_solid_position <= free_length
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
      max_working_shearstress = 8 * mean_diameter * max_force / (PI * (wire_diameter ** (3))) * k
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
      max_test_load_deformation = 8 * (mean_diameter ** (3)) * active_coil_num / (s_elastic_modulus * (wire_diameter ** (4))) * ffs
    else
      0
    end
  end

  def spring_length_check #弹簧长度校核
    if self.free_length.present? && self.active_coil_num.present? && active_coil_num > 0
      l = free_length - max_test_load_deformation
      if l > cd_length
        "弹簧最大试验负荷变形量小于弹簧最大工作变形量（自由长度太长）"
      elsif free_length < od_length
        "弹簧自由长度小于开门弹簧长度"
      else
        "长度可以实现"
      end
    end
  end

  def stress_coefficient # 最大切应力与抗拉强度的比值
    stress_coefficient = max_working_shear_stress / max_tensile_strength
  end

  def spring_attenuation_check
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
    Math.atan(spring_pitch / (PI * mean_diameter)) * 180 / PI
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

  # def is_flocking # 植绒判断
  #   if :flocking == "植绒"
  #     0.4
  #   else
  #     0
  #   end
  # end

  protected

  def should_validate_basic_data?
    current_step == 1 # 只有做到第二步需要验证
  end

  def should_validate_all_data?
    current_step == 3   # 做到第三步时需要验证
  end


end
