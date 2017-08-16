class AddPlatformIdToManualCalculation < ActiveRecord::Migration[5.0]
  def change
    add_column :manual_calculations, :platform_id, :integer
    add_index :manual_calculations, :platform_id
  end

end
