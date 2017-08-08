class CreatePlatforms < ActiveRecord::Migration[5.0]
  def change
    create_table :platforms do |t|
      t.string  :platform_name
      t.string  :platform_number
      t.timestamps
    end
  end
end
