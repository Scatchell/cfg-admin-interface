class CreateModel < ActiveRecord::Migration[5.0]
  def up
	create_table :models do |t|
	  t.string :color
	end
  end

  def down
	drop_table :models
  end
end
