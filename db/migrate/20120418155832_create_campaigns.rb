class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title, :null => false
      t.string :metatitle
      t.boolean :active, :null => false, :default => false
      t.datetime :start_at, :end_at, :null => false
      t.belongs_to :output, :null => false
      t.string :path_filter, :ua_filter
      t.timestamps
    end
    
    add_index(:campaigns, :output_id)
  end
end
