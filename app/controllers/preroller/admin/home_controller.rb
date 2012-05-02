module Preroller
  class Admin::HomeController < ApplicationController
  
    before_filter :authenticate_user!
    layout "preroller/admin"
  
    def index
    
    end
  
  end
end