class DnsServer
  include Mongoid::Document
  include Concerns::Server

  field :zone
  field :record_file

  # Validations
  validates_presence_of :zone, :record_file
end
