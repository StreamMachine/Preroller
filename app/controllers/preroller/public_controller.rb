module Preroller
  class PublicController < ApplicationController  
    # Handle a preroll request, delivering either a preroll file encoded in 
    # the format asked for by the stream or an empty response if there is no 
    # preroll
    def preroll
      # is this output key valid?
      @output = Output.where(:key => params[:key]).first
    
      if !@output
        render :text => "Invalid output key.", :status => :not_found and return
      end
    
      # Valid key.  Now, are there any running campaigns?
      campaigns = @output.campaigns.active
    
      # FIXME: Add path matching
      # FIXME: Add UI matching
    
      # for now, just return a random member of the list of matching, active 
      # campaigns.
      @campaign = campaigns.any? ? campaigns[ rand( campaigns.length ) ] : nil

      if @campaign
        # Now we need to figure out how to handle the stream key they've passed us
        # key format should be (codec)-(samplerate)-(channels)-(bitrate)-(mono/stereo)
        # For instance: mp3-44100-16-64-m, aac-44100-16-48-m, etc
      
        if file = @campaign.file_for_stream_key(params[:stream_key])
          # Got it... send a file
          send_file file, :disposition => 'inline' and return
        else
          render :text => "", :status => :ok and return
        end      
      else
        render :text => "", :status => :ok and return
      end
    end
  end
end