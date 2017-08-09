class AddSpringToPlatform < ActiveRecord::Migration[5.0]
  def change
    add_column :platforms, :spring_static_length, :float
    add_column :platforms, :inside_diameter, :float
    add_column :platforms, :max_tensile_strength, :integer, default: 2100, null: false
    add_column :platforms, :s_elastic_modulus, :integer, default: 78800, null: false
  end
end
