class CreateCompressionSprings < ActiveRecord::Migration[5.0]
  def change
    create_table :compression_springs do |t|
      t.string :product_name
      t.string :product_number, :index => true
      t.float :min_force
      t.float :max_force
      t.float :od_length
      t.float :cd_length
      t.float :inside_diameter
      t.float :wire_diameter
      t.float :active_coil_num
      t.float :total_num
      t.float :free_length
      t.float :od_force
      t.float :cd_force
      t.integer :max_tensile_strength, default: 2100, null: false
      t.integer :s_elastic_modulus, default: 78800, null: false
      t.timestamps
    end
  end
end
