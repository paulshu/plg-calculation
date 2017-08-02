class CompressionSpring < ApplicationRecord
  validates :product_name, presence:  { message: "请填写产品名称" }
  validates :product_number, presence:  { message: "请填写产品编号" }

  def total_num?
    if self.active_coil_num.present?
      self.total_num = self.active_coil_num + 2
      self.update_columns(total_num: total_num)
    end
  end

end
