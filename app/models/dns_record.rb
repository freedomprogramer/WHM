class DnsRecord
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Restriction
  include Concerns::Puppet

  field :domain_name
  field :ip_address
  field :type

  # Relations
  belongs_to :dns_server, :inverse_of => :dns_records
  has_one :nginx_site, dependent: :restrict, :inverse_of => :dns_record

  # Validations
  validates :domain_name, presence: true, uniqueness: true
  validates_exist_associated_object :dns_server

  # Callback
  before_save :generate_domain_full_name

  execute_puppet_after_save do
    add_dns_record dns_server.domain_name, 'record_file' => dns_server.record_file
  end

  execute_puppet_before_destroy do
    del_dns_record dns_server.domain_name, 'record_file' => dns_server.record_file
  end

  private
  def generate_domain_full_name
    self.domain_name = self.domain_name + '.' + dns_server.zone
  end
end
