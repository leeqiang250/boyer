<h1>新浪微博</h1>
    <ul id="weibo">
    <li>
   <iframe width="100%" height="550" class="share_self"  frameborder="0" scrolling="no" src="http://widget.weibo.com/weiboshow/index.php?language=&width=0&height=550&fansRow=2&ptype=1&speed=0&skin=1&isTitle=1&noborder=1&isWeibo=1&isFans=1&uid=1791281385&verifier=8c6f2d1f&dpc=1">
	   
   </iframe>

      </li>



<!--
{% capture category %}{{ post.categories | size }}{% endcapture %}
<h1><a href="{{ root_url }}{{ post.url }}">{% if site.titlecase %}{{ post.title | titlecase }}{% else %}{{ post.title }}{% endif %}</a></h1>
<time datetime="{{ post.date | datetime | date_to_xmlschema }}" pubdate>{{ post.date | date: "<span class='month'>%b</span> <span class='day'>%d</span> <span class='year'>%Y</span>"}}</time>
{% if category != '0' %}
<footer>
  <span class="categories">posted in {{ post.categories | category_links }}</span>
</footer>
{% endif %}
-->


gem 'octopress-popular-posts'
gem 'nokogiri', '1.6.2.1'