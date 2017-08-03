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
  validates :free_lengh, numericality:  { greater_than: 0, message: "弹簧自由长度必须大于0" }, :if => :should_validate_all_data?

  # :if 这个参数可以设定调用那一个方法来决定要不要启用这个验证，回传 true 就是要，回传 false 就是不要
  # 透过 attr_accessor :current_step 我们增加一个虚拟属性(也就是数据库中并没有这个字段)来代表目前做到哪一步, 并定义相关函数，且在controller中更新步骤。

  def total_num?
    if self.active_coil_num.present?
      self.total_num = self.active_coil_num + 2
      self.update_columns(total_num: total_num)
    end
  end

  def od_force?
    if self.active_coil_num.present? && self.free_lengh.present?
      self.od_force = (free_lengh - od_length) * spring_rate
    else
      self.od_force = 0
    end
    self.update_columns(od_force: od_force)
  end

  def cd_force?
    if self.active_coil_num.present? && self.free_lengh.present?
      self.cd_force = (free_lengh - cd_length) * spring_rate
    else
      self.cd_force = 0
    end
    self.update_columns(cd_force: cd_force)
  end

  # 以下为通用的弹簧参数
  Initial_wire_diameter = 3.8 # 初选线径
  PI = 3.1415926535
  def distortion # 变形量
    distortion = od_length - cd_length
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
    spring_theoretical_rate = (max_force - min_force) / distortion
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
    no_solid_position_active_coil_num = (cd_length - 13) / (wire_diameter + 0.4) - 2
  end

  def spring_rate # 实际刚度
    if self.active_coil_num.present?
      spring_rate = s_elastic_modulus * (wire_diameter ** (4)) / (8 * (mean_diameter ** (3)) * active_coil_num )
    end
  end

  def theoretical_free_lengh # 理论自由长度
    if self.spring_rate.present?
      f1 = min_force / spring_rate
      f2 = max_force / spring_rate
      theoretical_free_lengh = [(od_length + f1), (cd_length + f2)].min
    else
      0
    end
  end

  def spring_solid_position # 弹簧压并
    if self.free_lengh.present?
      spring_solid_position = (wire_diameter + 0.4) * total_num + 13
      if spring_solid_position <= cd_length && spring_solid_position <= free_lengh
        "弹簧不会压并"
      else
        "弹簧压并！"
      end
    end
  end

  protected

  def should_validate_basic_data?
    current_step == 1 # 只有做到第二步需要验证
  end

  def should_validate_all_data?
    current_step == 3   # 做到第三步时需要验证
  end


end
