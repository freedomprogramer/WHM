# -*- coding: utf-8 -*-
class SftpUsersController < ApplicationController
  def index
    @sftp_users = SftpUser.all
  end

  def new
    @sftp_user = SftpUser.new
  end

  def create
    @sftp_user = SftpUser.new(params[:sftp_user])

    if @sftp_user.save
      redirect_to sftp_users_path, notice: "新建 SFTP 用户 成功"
    else
      render 'new'
    end
  end

  def verify
    @sftp_user = SftpUser.find(params[:id])
    @sftp_user.verify if @sftp_user
    redirect_to :back, notice: '当前 SFTP 用户 状态验证成功，SFTP 用户 状态已更新'
  end

  def destroy
    @sftp_user = SftpUser.find(params[:id])
    if @sftp_user && @sftp_user.destroy
      redirect_to sftp_users_path, notice: "删除 SFTP 用户 成功" 
    else
      flash[:error] = '删除 SFTP 用户 失败'
      redirect_to sftp_users_path
    end
  end
end