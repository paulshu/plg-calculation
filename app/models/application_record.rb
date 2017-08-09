class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  PI = 3.1415926535
  include Math
end
