class AudioEncoding < ActiveRecord::Base  
  belongs_to :campaign

  #default_scope where("stream_key != 'master'")
  scope :master, where(:stream_key => "master")
  
  before_destroy :delete_cache_and_img
  
  STREAM_KEY_REGEX = /^(mp3|aac)-(44100|22050)-(32|48|64|96|128)-(m|s)$/
  
  def path
    if self.fingerprint
      File.join(Rails.application.config.preroller.audio_dir,"#{self.campaign.id}-#{self.fingerprint}.#{self.extension}")
    else
      return nil
    end
  end
  
  #----------
  
  # key format should be (codec)-(samplerate)-(channels)-(bitrate)-(mono/stereo)
  # For instance: mp3-44100-64-m, aac-44100-48-m, etc
  def self.valid_stream_key?(key)
    if STREAM_KEY_REGEX.match(key)
      return true
    else
      return false
    end
  end
  
  #----------
  
  def fire_resque_encoding
    # don't fire if we're already encoded...
    return false if self.path
    
    return true
  end

  #----------
  
  def _encode
    # get the campaign's master
    master = self.campaign.encodings.master.first
    
    # chop up our stream key
    keyparts = STREAM_KEY_REGEX.match self.stream_key
    
    # we need to take master.path and encode it using our stream key
    # we'll encode into a temp file and then move it into place
    f = Tempfile.new('preroller')
    
    acodec = nil
    
    if keyparts[1] == "mp3"
      acodec = "libmp3lame"
    elsif keyparts[1] == "aac"
      acodec = "labfaac"
    end
    
    begin
    
      mfile = FFMPEG::Movie.new(master.path)
      mfile.transcode(f.path,{ 
        :custom             => "-f #{keyparts[1]}",
        :audio_codec        => acodec, 
        :audio_sample_rate  => keyparts[2],
        :audio_bitrate      => keyparts[3],
        :audio_channels     => keyparts[4] == "s" ? 2 : 1
      })
      
      # make sure the file we created is valid...
      newfile = FFMPEG::Movie.new(f.path)
      
      if newfile.valid?
        # add our attributes
        self.attributes = {
          :size       => newfile.size,
          :duration   => newfile.duration,
          :extension  => newfile.audio_codec
        }
      
        # grab a fingerprint
        self.fingerprint = Digest::MD5.hexdigest(f.read)
        f.rewind if f.respond_to?(:rewind)

        # now write it into place in our final location
        File.open(self.path,"w") do |ff|
          ff << f.read()
        end
        
        # save our new values
        self.save()
      end
    ensure
      f.close
      f.unlink
    end
    
    return true
  end
  
  #----------
  
  private
  def delete_cache_and_img
    # delete our file
    File.delete(self.path) if File.exists?(self.path)
    
    # delete cache?
    
  end
  
end
