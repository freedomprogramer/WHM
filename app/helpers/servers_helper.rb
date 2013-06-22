module ServersHelper
  def server_type key
    Settings.servers.types[key]
  end
end