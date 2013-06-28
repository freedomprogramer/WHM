require 'net/http'

class NginxSite
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Puppet
  include Concerns::Verify

  field :site_name

  # Relations
  belongs_to :sftp_user, :inverse_of => :nginx_sites
  belongs_to :dns_record, :inverse_of => :nginx_site

  # Validations
  validates_presence_of :site_name, :sftp_user, :dns_record
  validates_uniqueness_of :site_name
  validates_exist_associated_object :sftp_user, :dns_record

  # Callback
  execute_puppet_after_save do
    add_nginx_site sftp_user.nginx_server.domain_name,
    'site_directory' => site_root_directory, 'site_domain' => dns_record.domain_full_name, 'owner' => sftp_user.username
  end

  execute_puppet_before_destroy do
    del_nginx_site sftp_user.nginx_server.domain_name,
    'site_directory' => site_root_directory, 'site_domain' => dns_record.domain_full_name, 'owner' => sftp_user.username
  end

  def site_root_directory
    File.join( sftp_user.home, site_name)
  end

  def verify_method
    begin
    Net::HTTP.get_response(URI("http://#{dns_record.domain_full_name}")).code == '200' ? true :false
    rescue SocketError; false; end      
  end
end
