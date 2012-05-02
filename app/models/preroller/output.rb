module Preroller
  class Output < ActiveRecord::Base
    has_many :campaigns
    attr_accessible :key, :description
  end
end