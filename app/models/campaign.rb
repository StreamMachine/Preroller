class Campaign < ActiveRecord::Base
  class InvalidAudioError < Error
  end
  
  belongs_to :output
  has_many :encodings, :class_name => "AudioEncoding", :dependent => :destroy
  
  scope :active, lambda { where("start_at < ? and end_at > ? and active = 1",Time.now,Time.now) }
  
  #----------
  
  def fingerprint
    m = self.encodings.master.first
    return m ? m.fingerprint : false
  end
  
  #----------
  
  # Takes a stream key and returns a file path
  # Stream key format: (codec)-(samplerate)-(channels)-(bitrate)-(m/s)
  # For instance: mp3-44100-16-64-m, aac-44100-16-48-m, etc
  def file_for_stream_key(key)
    # -- do we have a cache for this campaign and key? -- #

    if self.fingerprint && (c = Rails.cache.read("#{self.id}-#{self.fingerprint}:#{key}"))
      return c
    end
    
    # -- is this a valid stream key? -- #
    
    if AudioEncoding.valid_stream_key?(key)
      # -- do we have an encoded output? -- #
      
      ae = self.encodings.where(:stream_key => key).first
      
      if ae
        # yes, but does it have a path yet?
        if p = ae.path
          return p
        else
          # should be encoding right now...  just return as if we don't have a preroll
          return nil
        end
      else
        # no...  create an encoding and fire it
        ae = self.encodings.create(:stream_key => key)
        ae.fire_resque_encoding()
        
        return nil
      end
    else
      # invalid stream key
      raise InvalidAudioError
    end
    
  end
  
  #----------
  
  def save_master_file(f)
    # -- make sure it's a valid audio file -- #
    
    snd = FFMPEG::Movie.new(f.path)
        
    if !snd.valid?
      raise InvalidAudioError
    end
    
    # -- find or create master AudioEncoding -- #
    
    master = self.encodings.master.first || self.encodings.create(:stream_key => "master")
    
    # grab the extension of the input file
    ext_match = /\.(\w+)/.match(f.original_filename)
    
    ext = nil
    if ext_match
      ext = ext_match[1]
    end
    
    master.attributes = {
      :size       => snd.size,
      :duration   => snd.duration,
      :extension  => ext || snd.audio_codec
    }
        
    # -- get a fingerprint -- #

    master.fingerprint = Digest::MD5.hexdigest(f.read)
    f.rewind if f.respond_to?(:rewind)
    
    puts "fingerprint is #{print}"
    
    # -- save -- #
    
    File.open( master.path, "w", :encoding => "ascii-8bit") do |newf|
      newf << f.read()
    end
    
    master.save()
    
    # -- delete any other existing AudioEncodings -- #
    
    self.encodings.each do |ae|
      next if ae == master
      ae.destroy()
    end
    
    # -- update our own active status -- #
    
    self.active = true
    self.save()
    
    return true
  end
  
  #----------
end
