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
      redirect_to dns_records_path, notice: "新建 DNS 信息成功"
    else
      render 'new'
    end
  end

  def destroy
    @dns_record = DnsRecord.find(params[:id])
    if @dns_record.destroy
      redirect_to dns_records_path, notice: "删除  DNS 信息成功"
    else
      redirect_to dns_records_path, notice: "删除  DNS 信息失败"
    end
  end
end
