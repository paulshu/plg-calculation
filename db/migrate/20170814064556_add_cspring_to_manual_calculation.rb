class AddCspringToManualCalculation < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_calculations, :wire_diameter, :float, default: 3.6, null: false
    add_column :manual_calculations, :active_coil_num, :float
    add_column :manual_calculations, :free_length, :float
    add_column :manual_calculations, :flocking, :string
    add_column :manual_calculations, :climbing_degree, :float, default: 0.2, null: false
  end
end
