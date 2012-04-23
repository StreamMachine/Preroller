class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate!
    if !current_user
      redirect_to new_user_session_path
    else
      # ok
    end
  end
  
  #----------
  
  def after_sign_in_path_for(resource)
    loc = (stored_location_for(resource)||"").gsub("//",'/')
    loc || admin_root_path
  end
  
end
