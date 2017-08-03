module CompressionSpringsHelper

  def render_spring_theoretical_rate(compression_spring)
    compression_spring.spring_theoretical_rate
  end

  def render_theoretical_wire_diameter(compression_spring)
    compression_spring.theoretical_wire_diameter
  end

  def render_theoretical_active_coil_num(compression_spring)
    compression_spring.theoretical_active_coil_num
  end

  def render_no_solid_position_active_coil_num(compression_spring)
    compression_spring.no_solid_position_active_coil_num
  end

  def render_spring_rate(compression_spring)
    if compression_spring.spring_rate.present?
      compression_spring.spring_rate
    else
      0
    end
  end

  def render_theoretical_free_lengh(compression_spring)
    compression_spring.theoretical_free_lengh
  end

  def render_spring_solid_position(compression_spring)
    compression_spring.spring_solid_position
  end
end
