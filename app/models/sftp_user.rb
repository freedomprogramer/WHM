class SftpUser
  include Mongoid::Document
  include Concerns::User
  include Concerns::Association

  field :home

  # Relations
  belongs_to :nginx_server, :inverse_of => :sftp_users

  # Validations
  validates_exist_associated_object :nginx_server

  # Callbacks
  before_validation :generate_home

  def generate_home
    self.home ||=  File.join( Settings.sftp.chroot, username )
  end

  def encrypt_password
    self.password = `openssl passwd -1 -salt #{random_string(8)} #{password}`.chomp
    self.password_confirmation = `openssl passwd -1 -salt #{random_string(8)} #{password_confirmation}`.chomp
  end
end
