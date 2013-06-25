class NginxServer
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Puppet
  include Concerns::Server

  has_many :sftp_users, dependent: :restrict, :inverse_of => :nginx_server
end
