$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "preroller/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "preroller"
  s.version     = Preroller::VERSION
  s.authors     = ["Eric Richardson"]
  s.email       = ["e@ericrichardson.com"]
  s.homepage    = "http://github.com/SCPR/Preroller"
  s.summary     = "Rails engine to manage and deliver audio prerolls"
  s.description = "Rails engine to manage and deliver audio prerolls"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "streamio-ffmpeg"
  s.add_dependency "formtastic"
  s.add_dependency "formtastic-bootstrap"
  s.add_dependency "less-rails-bootstrap"
  s.add_dependency "resque"
  s.add_dependency "devise"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
