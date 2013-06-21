class NginxSite
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Puppet

  field :site_name

  # Relations
  belongs_to :sftp_user, :inverse_of => :nginx_sites
  belongs_to :dns_record, :inverse_of => :nginx_site

  # Validations
  validates :site_name, presence: true, uniqueness: true
  validates_exist_associated_object :sftp_user, :dns_record

  # Callback
  execute_puppet_after_save do
    add_nginx_site sftp_user.nginx_server.domain_name,
    'site_directory' => site_root_directory
  end

  execute_puppet_before_destroy do
    del_nginx_site sftp_user.nginx_server.domain_name,
    'site_directory' => site_root_directory
  end

  def site_root_directory
    File.join( sftp_user.home, site_name)
  end
end
