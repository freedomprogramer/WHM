# -*- coding: utf-8 -*-
class DnsRecordsController < ApplicationController
  def index
    @dns_records = DnsRecord.all
  end

  def new
    @dns_record = DnsRecord.new
  end

  def create
    @dns_record = DnsRecord.new(params[:dns_record])

    if @dns_record.save
      redirect_to dns_records_path, notice: "新建 DNS 记录 成功"
    else
      render 'new'
    end
  end

  def check_state
    @dns_record = DnsRecord.find(params[:id])
    @dns_record.add_and_check_status if @dns_record
    redirect_to :back, notice: '当前 DNS 记录 状态验证成功，DNS 记录 状态已更新'
  end

  def destroy
    @dns_record = DnsRecord.find(params[:id])
    if @dns_record && @dns_record.destroy
      redirect_to dns_records_path, notice: "删除 DNS 记录 成功"
    else
      flash[:error] = '删除 DNS 记录 失败'
      redirect_to dns_records_path
    end
  end
end