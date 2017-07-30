class CreateCompressionSprings < ActiveRecord::Migration[5.0]
  def change
    create_table :compression_springs do |t|
      t.float :min_force
      t.float :max_force
      t.float :od_length
      t.float :cd_length
      t.float :inside_diameter
      t.float :wire_diameter
      t.float :active_coil_number
      t.float :free_lengh
      t.float :od_force
      t.float :cd_force
      t.timestamps
    end
  end
end
