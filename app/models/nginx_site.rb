class NginxSite
  include Mongoid::Document
  include Concerns::Association

  field :site_name

  # Relations
  belongs_to :sftp_user, :inverse_of => :nginx_sites
  belongs_to :dns_record, :inverse_of => :nginx_site

  # Validations
  validates :site_name, presence: true, uniqueness: true
  validates_exist_associated_object :sftp_user, :dns_record
end
