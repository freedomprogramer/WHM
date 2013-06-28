class DnsServer
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Puppet
  include Concerns::Server
  include Concerns::Verify

  field :zone
  field :record_file

  # Validations
  validates_presence_of :zone, :record_file

  has_many :dns_records, dependent: :restrict, :inverse_of => :dns_server

  def verify_method
    ssh_login(self.domain_name, 'ls')
    $?.exitstatus == 0 ? true : false
  end  
end