class CreateAudioEncodings < ActiveRecord::Migration
  def change
    create_table :preroller_audio_encodings do |t|
      t.belongs_to :campaign, :null => false
      t.string :stream_key, :null => false
      t.string :fingerprint, :extension
      t.integer :size
      t.integer :duration
      t.timestamps
    end
    
    add_index(:preroller_audio_encodings, [:campaign_id,:stream_key], :unique => true)
  end
end
