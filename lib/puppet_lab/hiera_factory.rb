# -*- coding: utf-8 -*-
require 'erb'

module PuppetLab
  class HieraFactory

    def initialize domain
      @domain = domain
    end

    # 获取 puppet hiera_templates 目录下所有的模板文件名
    def self.hiera_templates
      Dir.foreach( Settings.puppet.hiera_templates ).map{|x| x.chomp(".yaml.erb")}
        .delete_if{ |i| ['.', '..'].include? i }
    end

    # 以模板文件名为方法名，定义方法接受 Hash
    # 定义的方法作用是： 通过 hiera 模板文件生成对应的 yaml 文件
    hiera_templates.each do | method_name |
      define_method method_name do | params |
        if params.is_a? Hash

          p params

          puts( ERB.new( File.read (template_file method_name) ).result binding)
          
          File.open( hieradata_file, 'w') do |f|
            f.puts( ERB.new( File.read (template_file method_name) ).result binding)
          end
        else
          raise ArgumentError, 'Argument must be an Hash'
        end
      end
    end

    # 指定文件名的模板文件绝对路径
    def template_file file_name
      File.join( Settings.puppet.hiera_templates, file_name.to_s + '.yaml.erb')
    end

    # 以域名为文件名的 hieradate 文件绝对路径
    def hieradata_file
      File.join( Settings.puppet.hieradata,  @domain + '.yaml')
    end
    
  end
end
