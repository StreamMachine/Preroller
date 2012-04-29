if Rails.env == "scprdev"
  FFMPEG.ffmpeg_binary = "/usr/local/bin/ffmpeg"
end