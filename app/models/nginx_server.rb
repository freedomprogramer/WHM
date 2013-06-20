class NginxServer
  include Mongoid::Document
  include Concerns::Server
  include Concerns::Restriction

  has_many :sftp_users, dependent: :restrict, :inverse_of => :nginx_server
end
