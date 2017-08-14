class AddCspringToManualCalculation < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_calculations, :wire_diameter, :float
    add_column :manual_calculations, :active_coil_num, :float
    add_column :manual_calculations, :free_length, :float
    add_column :manual_calculations, :flocking, :string

  end
end
