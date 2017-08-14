class ManualCalculation < ApplicationRecord

  validates :product_name, presence:  { message: "请填写产品或项目名称" }
  validates :product_number,  presence:  { message: "请填写产品编号" },
                             uniqueness: { message: "产品编号重复了" }
  validates :hinge_x, presence:  { message: "请填写旋转中心坐标" }
  validates :hinge_y, presence:  { message: "请填写旋转中心坐标" }
  validates :hinge_z, presence:  { message: "请填写旋转中心坐标" }
  validates :centre_gravity_x, presence:  { message: "请填写重心坐标" }
  validates :centre_gravity_y, presence:  { message: "请填写重心坐标" }
  validates :centre_gravity_z, presence:  { message: "请填写重心坐标" }
  validates :open_handle_x, presence:  { message: "请填写手动开门点坐标" }
  validates :open_handle_y, presence:  { message: "请填写手动开门点坐标" }
  validates :open_handle_z, presence:  { message: "请填写手动开门点坐标" }
  validates :close_handle_x, presence:  { message: "请填写手动关门点坐标" }
  validates :close_handle_y, presence:  { message: "请填写手动关门点坐标" }
  validates :close_handle_z, presence:  { message: "请填写手动关门点坐标" }
  validates :door_weight, presence:  { message: "请填写门重，单位kg" }
  validates :open_angle, presence:  { message: "请填写开门角度" }
  validates :open_time, presence:  { message: "请填写开门时间" }
  validates :close_time, presence:  { message: "请填写开门时间" }
  validates :open_dynamic_friction, presence:  { message: "请填写开门阻力（动摩擦力）" }
  validates :close_dynamic_friction, presence:  { message: "请填写关门阻力（动摩擦力）" }
  validates :open_static_friction, presence:  { message: "请填写开门阻力（静摩擦力）" }
  validates :close_static_friction, presence:  { message: "请填写关门阻力（静摩擦力）" }
  validates :body_a_x, presence:  { message: "请填写车身A点坐标" }
  validates :body_a_y, presence:  { message: "请填写车身A点坐标" }
  validates :body_a_z, presence:  { message: "请填写车身A点坐标" }
  validates :gate_b_x, presence:  { message: "请填写车门B点坐标" }
  validates :gate_b_y, presence:  { message: "请填写车门B点坐标" }
  validates :gate_b_z, presence:  { message: "请填写车门B点坐标" }

belongs_to :platform
# belongs_to :platform, inverse_of: :manual_calculations
# 报错时考虑用
# belongs_to :user

def o_centre_gravity_z
  
end

end
