class AddGearboxToPlatform < ActiveRecord::Migration[5.0]
  def change
    add_column :platforms, :gearbox_type, :string
    add_column :platforms, :gear_transmission_ratio, :float
    add_column :platforms, :gear_transmission_efficiency, :float
  end
end
