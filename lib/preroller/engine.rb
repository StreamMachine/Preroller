require "resque"

module Preroller
  class Engine < ::Rails::Engine
    isolate_namespace Preroller
    
    config.preroller = ActiveSupport::OrderedOptions.new
    
    # -- Set up Resque -- #
    
    initializer :set_up_preroller_resque do
      app_config = "#{Rails.application.root}/config/resque.yml"
      
      resque_config = YAML.load_file(
        File.exists?(app_config) ? app_config : File.expand_path("../../../config/resque.yml",__FILE__)
      )
      
      Resque.redis = resque_config[Rails.env]
    end
    
    # -- Set the Resque Queue -- #
    
    config.after_initialize do
      Preroller::AudioEncoding.instance_variable_set :@queue, Rails.application.config.preroller.resque_queue || "preroller"
    end
    
    # -- Add Resque rake tasks -- #
    
    rake_tasks do
      require "resque/tasks"
    end
  end
end
