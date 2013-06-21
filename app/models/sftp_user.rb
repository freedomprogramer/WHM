class SftpUser
  include Mongoid::Document
  include Concerns::User
  include Concerns::Association
  include Concerns::Restriction
  include Concerns::Puppet

  field :home

  # Relations
  belongs_to :nginx_server, :inverse_of => :sftp_users
  has_many :nginx_sites, dependent: :restrict, :inverse_of => :sftp_user

  # Validations
  validates_exist_associated_object :nginx_server

  # Callbacks
  before_validation :generate_home

  # Callback
  execute_puppet_after_save do
    add_sftp_user nginx_server.domain_name
  end

  execute_puppet_before_destroy do
    del_sftp_user nginx_server.domain_name
  end

  def generate_home
    self.home ||=  File.join( Settings.sftp.chroot, username )
  end

  def encrypt_password
    self.password = `openssl passwd -1 -salt #{random_string(8)} #{password}`.chomp
    self.password_confirmation = `openssl passwd -1 -salt #{random_string(8)} #{password_confirmation}`.chomp
  end
end
