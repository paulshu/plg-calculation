class Platform < ApplicationRecord

  validates :platform_name, presence:  { message: "请填写平台名称" }
  validates :platform_number, presence:  { message: "请填写平台编号" },
                              length: {maximum: 11, message: "太长，编号不能超过11位"}
  validates :screw_name, presence:  { message: "请填写螺杆名称" }
  validates :number, presence:  { message: "请填写螺杆头数" }
  validates :pitch, presence:  { message: "请填写螺距" }
  validates :major_diameter, presence:  { message: "请填写螺杆大径" }
  validates :thread_angle, presence:  { message: "请填写螺杆牙型角" }
  validates :coefficient_friction, presence:  { message: "请填写螺杆摩擦系数" }
  validates :gearbox_type, presence:  { message: "请填写减速箱型号" }
  validates :gear_transmission_ratio, presence:  { message: "请填写减速箱减速比" }
  validates :gear_transmission_efficiency, presence:  { message: "请填写减速箱效率" }
  validates :motor_type, presence:  { message: "请填写电机型号" }
  validates :min_operating_voltage, presence:  { message: "请填写电机最小电压" }
  validates :rated_voltage, presence:  { message: "请填写电机额定电压" }
  validates :rated_current, presence:  { message: "请填写电机额定电流" }
  validates :rated_speed, presence:  { message: "请填写电机额定转速" }
  validates :motor_efficiency, presence:  { message: "请填写电机效率" }
  validates :spring_static_length, presence:  { message: "请填写弹簧静长" }
  validates :inside_diameter, presence:  { message: "请填写弹簧内径" }


  def pitch_diameter? # 螺杆中径
    pd = major_diameter - 0.5 * pitch
    self.update_columns(pitch_diameter: pd)
  end

  def lead? # 螺杆导程
    lead = number * pitch
    self.update_columns(lead: lead)
  end

  def lead_angle # 螺旋升角
    180/PI * atan(lead / (PI * pitch_diameter))
  end

  def friction_angle # 当量摩擦角ρ
    180 / PI * atan(coefficient_friction / cos((thread_angle / 2) * (PI / 180) ))
  end

  def screw_transmission_efficiency  # 传动效率η
    0.97 * tan(lead_angle / 180 * PI) /tan((lead_angle + friction_angle) / 180 * PI)
  end
end
