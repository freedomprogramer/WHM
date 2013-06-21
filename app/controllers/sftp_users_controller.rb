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
      redirect_to sftp_users_path, notice: "新建 SFTP 用户成功"
    else
      render 'new'
    end
  end

  def edit
    @sftp_user = SftpUser.find(params[:id])
  end

  def update
    @sftp_user = SftpUser.find(params[:id])

    if @sftp_user.update_attributes(params[:sftp_user])
      redirect_to sftp_users_path, notice: "更新用户成功"
    else
      render 'edit'
    end
  end

  def destroy
    @sftp_user = SftpUser.find(params[:id])
    if @sftp_user.destroy
      redirect_to sftp_users_path, notice: "删除用户成功" 
    else
      redirect_to sftp_users_path, notice: "删除用户失败" 
    end
  end
end
