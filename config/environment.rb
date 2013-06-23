# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
WHM::Application.initialize!

# RubyCAS-Clinet
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://vhostman.cdu.edu.cn:8000"
)