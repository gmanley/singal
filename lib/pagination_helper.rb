require 'will_paginate/view_helpers/base'
require 'will_paginate/view_helpers/link_renderer'

WillPaginate::ViewHelpers::LinkRenderer.class_eval do
  protected

  def page_number(page)
    unless page == current_page
      tag(:li, link(page, page, :rel => rel_value(page)))
    else
      tag(:li, tag(:p, page), :class => 'current')
    end
  end

  def gap
    '<li class="gap">&hellip;</li>'
  end

  def previous_or_next_page(page, text, classname)
    if page
      tag(:li, link(text, page), :class => classname)
    else
     tag(:li, tag(:p, text), :class => classname + ' disabled')
    end
  end

  def html_container(html)
    tag(:ul, html, container_attributes)
  end

  def url(page)
    url = @template.request.url
    if page == 1
      url.gsub(/page\/[0-9]+/, '')
    else
      if url =~ /page\/[0-9]+/
        url.gsub(/page\/[0-9]+/, "page/#{page}")
      else
        url + "page/#{page}"
      end
    end
  end
end