class ServersController < ApplicationController
  def index
    @server_types = Settings.servers
    @servers = Settings.servers.map { |k, v| Object.const_get(k.camelcase).all }.flatten!
  end

  def new
    @server_type = params[:server][:type]
    unless @server_type.blank?
      @server = Object.const_get( @server_type.camelcase ).new
      return render "_#{@server_type}"
    end
    redirect_to servers_path, notice: "请选择新建服务器类型"
  end

  def create
    @server_type = params[:server][:server_type]
    unless @server_type.blank?
      @server = Object.const_get( @server_type.camelcase ).new(params[:server])

      if @server.save
        return redirect_to servers_path, notice: "服务器创建成功"
      else
        return render "_#{@server_type}"
      end
    end
    redirect_to servers_path, notice: "请选择新建服务器类型"
  end

  def destroy
    @server = Object.const_get( params[:server_type].camelcase ).find(params[:id])
    redirect_to servers_path, notice: "删除服务器成功" if @server.destroy
  end
end
