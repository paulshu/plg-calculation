class AddMotorToPlatform < ActiveRecord::Migration[5.0]
  def change
    add_column :platforms, :motor_type, :string
    add_column :platforms, :min_operating_voltage, :float
    add_column :platforms, :rated_voltage, :float
    add_column :platforms, :rated_current, :float
    add_column :platforms, :rated_speed, :integer
    add_column :platforms, :motor_efficiency, :float
  end
end
