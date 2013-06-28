class NginxServer
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Puppet
  include Concerns::Server
  include Concerns::Verify

  has_many :sftp_users, dependent: :restrict, :inverse_of => :nginx_server

  def verify_method
    ssh_login(self.domain_name, 'ls')
    $?.exitstatus == 0 ? true : false
  end
end
