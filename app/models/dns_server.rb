class DnsServer
  include Mongoid::Document
  include Concerns::Server
  include Concerns::Restriction

  field :zone
  field :record_file

  # Validations
  validates_presence_of :zone, :record_file

  has_many :dns_records, dependent: :restrict, :inverse_of => :dns_server
end
