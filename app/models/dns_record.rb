class DnsRecord
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Restriction

  field :domain_name
  field :ip_address
  field :type

  # Relations
  belongs_to :dns_server, :inverse_of => :dns_records
  has_one :nginx_site, dependent: :restrict, :inverse_of => :dns_record

  # Validations
  validates :domain_name, presence: true, uniqueness: true
  validates_exist_associated_object :dns_server
end
