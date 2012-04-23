require 'digest/sha1'

class User < ActiveRecord::Base
  establish_connection "mercer"
  self.table_name = "auth_user"
  
  devise :database_authenticatable, :authentication_keys => [:username]
  
  attr_accessible :email, :password, :password_confirmation, :username
  
  #----------
  
  alias :devise_valid_password? :valid_password?
  def valid_password?(pwd)
    # format is sha1$(salt)$(hash)
    self[:password] =~ /^sha1\$(\w+)\$/
    
    if self[:password] == "sha1$#{$~[1]}$" + Digest::SHA1.hexdigest($~[1]+pwd)
      return true
    else
      return false
    end
  end
  
  def encrypted_password
    return self[:password]
  end
  
  def is_admin?
    self[:is_superuser] ? true : false
  end
end


#----------

