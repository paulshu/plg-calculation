class CompressionSpring < ApplicationRecord
  validates :product_name, presence:  { message: "请填写产品名称" }
  validates :product_number, presence:  { message: "请填写产品编号" }

  # def compression_spring_calulation!
  #   @total_num = :active_coil_num + 2
  #   total_num = @total_num
  # end
end
