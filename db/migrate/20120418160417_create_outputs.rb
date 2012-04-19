class CreateOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.string :key, :null => false, :max => 15, :unique => true
      t.text :description
      t.timestamps
    end
  end
end
