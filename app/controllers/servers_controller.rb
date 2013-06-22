# -*- coding: utf-8 -*-
class ServersController < ApplicationController
  before_filter :find_server_type, only: [:new, :create, :destroy]

  def index
    @server_types = Settings.servers.types
    @servers = Settings.servers.types.map { |k, v| Object.const_get(k.camelcase).all }.flatten!
  end

  def new
    server_type_not_exist? ? return : @server = server_class.new
  end

  def create
    return if server_type_not_exist?

    @server = server_class.new(params[:server])
    if @server.save
      return redirect_to servers_path, notice: '新建 服务器 成功'
    else
      return render 'new'
    end
  end

  def destroy
    @server = server_class.find(params[:id])
    if @server && @server.destroy
      redirect_to servers_path, notice: "删除 服务器 成功"
    else
      flash[:error] = '删除 服务器 失败'
      redirect_to servers_path
    end
  end

  private
  def find_server_type
    @server_type = params[:server][:type]
  end

  def server_class
    Object.const_get( @server_type.camelcase )
  end

  def server_type_not_exist?
    if @server_type.blank?
      flash[:error] = '请先选择新建服务器类型'
      redirect_to servers_path
    end
  end
end