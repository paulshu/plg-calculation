class AddScrewToPlatform < ActiveRecord::Migration[5.0]
  def change
    add_column :platforms, :screw_name, :string
    add_column :platforms, :number, :integer # (Number of threads)
    add_column :platforms, :pitch, :float
    add_column :platforms, :major_diameter, :float
    add_column :platforms, :pitch_diameter, :float
    add_column :platforms, :lead, :float
    add_column :platforms, :thread_angle, :float
    add_column :platforms, :coefficient_friction, :float

  end
end
