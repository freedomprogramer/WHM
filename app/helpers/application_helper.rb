# -*- coding: utf-8 -*-
module ApplicationHelper
  def delete_button link
    button_tag "删除", :class => 'btn btn-mini btn-danger', onclick: "delete_confirm({url: '#{link}'});"
  end

  # ------------------------------------ overlay --------------------------------------------
  def overlay_hidden_div
    content_tag :div, id: 'overlay' do
      content_tag :div, id: 'content' do
        "正在后台努力为你执行操作，请耐心等待。。。"
      end
    end
  end

  # ---------------------------------------breadcrumb helper---------------------------------
  # breadcrumb 导航菜单 helper，如果 breadcrumb 大于等于 3 级时，可以自定义 第三级 的现实内容
  def breadcrumb text = nil
    content_for :breadcrumb do
      breadcrumb_header do
        path_array = request.path.split('/')
        if path_array.size == 0
          breadcrumb_last t("breadcrumb.homes.index")
        elsif path_array.size == 2
          breadcrumb_item( t("breadcrumb.homes.index"), root_path ) <<
            breadcrumb_last( t("breadcrumb.#{path_array[1]}.index") )
        elsif path_array.size >= 3
          breadcrumb_item( t("breadcrumb.homes.index"), root_path ) <<
            breadcrumb_item( t("breadcrumb.#{path_array[1]}.index"), send("#{path_array[1]}_path") ) <<
            breadcrumb_last( text.blank? ? t("breadcrumb.#{path_array[1]}.#{path_array[2]}") : text)
        end
      end
    end
  end

  def breadcrumb_header
    content_tag :ul, class: 'breadcrumb' do
      yield
    end
  end

  def breadcrumb_item text, link
    content_tag :li do
      link_to(text, link) <<
        content_tag(:span, class: 'divider'){'/'}
    end
  end

  def breadcrumb_last text
    content_tag( :li, class: 'active' )do
      text
    end
  end
end