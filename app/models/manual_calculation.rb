class ManualCalculation < ApplicationRecord

  validates :product_name, presence:  { message: "请填写产品或项目名称" }
  validates :product_number,  presence:  { message: "请填写产品编号" },
                              uniqueness: { message: "产品编号重复了" }
end
