class DnsRecord
  include Mongoid::Document
  include Concerns::Association
  include Concerns::Puppet
  include Concerns::Verify

  field :domain_name
  field :ip_address
  field :type

  # Relations
  belongs_to :dns_server, :inverse_of => :dns_records
  has_one :nginx_site, dependent: :restrict, :inverse_of => :dns_record

  # Validations
  validates_presence_of :domain_name, :ip_address, :type, :dns_server
  validates_uniqueness_of :domain_name
  validates_exist_associated_object :dns_server

  # Callback
  execute_puppet_after_save do
    add_dns_record dns_server.domain_name, 'record_file' => dns_server.record_file
  end

  execute_puppet_before_destroy do
    del_dns_record dns_server.domain_name, 'record_file' => dns_server.record_file
  end

  def domain_full_name
    self.domain_name + '.' + dns_server.zone
  end

  def self.usable_record
    all.map { |e| e if e.nginx_site.blank? }.compact
  end

  def verify_method
    grep_line = ssh_login(self.dns_server.domain_name, "cat #{self.dns_server.record_file} | grep -c \"#{self.domain_name}\t\"")
    $? == 0 && grep_line == '1' ? true :false
  end
end