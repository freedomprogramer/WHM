class NginxSitesController < ApplicationController
  def index
    @nginx_sites = NginxSite.all
  end

  def new
    @nginx_site = NginxSite.new
  end

  def create
    @nginx_site = NginxSite.new(params[:nginx_site])

    if @nginx_site.save
      redirect_to nginx_sites_path, notice: "新建 NGINX 站点成功"
    else
      render 'new'
    end
  end

  def destroy
    @nginx_site = NginxSite.find(params[:id])
    if @nginx_site.destroy
      redirect_to nginx_sites_path, notice: "删除 NGINX 站点 成功"
    else
      redirect_to nginx_sites_path, notice: "删除 NGINX 站点 失败"
    end
  end
end
