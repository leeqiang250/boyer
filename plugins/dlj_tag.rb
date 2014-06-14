# -*- encoding : utf-8 -*-
require 'fileutils'
require 'digest/md5'
require 'dljbz'

DLJ_CACHE_DIR = File.expand_path('../../.dlj-cache', __FILE__)
FileUtils.mkdir_p(DLJ_CACHE_DIR)

module Jekyll
  class DljTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      output = super
      config = context.registers[:site].config
      url =config['url']
      page_url = context.environments.first["page"]["url"]
      current_url = "#{url}#{page_url}"
      if defined?(DLJ_CACHE_DIR)
        path = File.join(DLJ_CACHE_DIR, "dlj-#{Digest::MD5.hexdigest(current_url)}")
        if File.exist?(path)
          dlj_url = File.read(path)
        else
          dlj_url = Dljbz.shorten(current_url).short_url
          File.open(path, 'w') {|f| f.print(dlj_url) }
        end
      else
        dlj_url = Dljbz.shorten(current_url).short_url
      end
      dlj =  "<div class='dljbz' style='font-size:14px;'>"
      dlj += "快链：<a href='#{dlj_url}'>#{dlj_url}</a>"
      dlj += "</div>"
    rescue Exception => e
      puts "......dlj error: #{e.inspect}"
    end
  end

end

Liquid::Template.register_tag('dlj_tag', Jekyll::DljTag)