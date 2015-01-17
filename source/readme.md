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


brew install libiconv

brew link libiconv --force

sudo gem install nokogiri -- --with-iconv-dir=/usr/local/Cellar/libiconv/1.14

bundle install

brew uninstall rbenv
brew uninstall ruby-build

admindeair:MyBlog admin$ brew install libiconv
==> Downloading http://ftpmirror.gnu.org/libiconv/libiconv-1.14.tar.gz
######################################################################## 100.0%
==> Downloading https://trac.macports.org/export/89276/trunk/dports/textproc/libiconv/files/patch-Makefile
######################################################################## 100.0%
==> Downloading https://trac.macports.org/export/89276/trunk/dports/textproc/libiconv/files/patch-utf8mac.
######################################################################## 100.0%
==> Patching
patching file Makefile.devel
Hunk #1 succeeded at 106 (offset 1 line).
patching file lib/converters.h
patching file lib/encodings.def
patching file lib/utf8mac.h
patching file lib/flags.h
==> ./configure --prefix=/usr/local/Cellar/libiconv/1.14 --enable-extra-encodings
==> make -f Makefile.devel CFLAGS= CC=clang
==> make install
==> Caveats
This formula is keg-only, so it was not symlinked into /usr/local.

Mac OS X already provides this software and installing another version in
parallel can cause all kinds of trouble.

Generally there are no consequences of this for you. If you build your
own software and it requires this formula, you'll need to add to your
build variables:

    LDFLAGS:  -L/usr/local/opt/libiconv/lib
    CPPFLAGS: -I/usr/local/opt/libiconv/include

==> Summary
🍺  /usr/local/Cellar/libiconv/1.14: 26 files, 1.4M, built in 72 seconds



