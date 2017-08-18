class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # PI = 3.1415926535 Math中已经默认定义了PI
  include Math
end
