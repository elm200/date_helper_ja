#
# DateHelperJa
#
# Japanizes ActionView::Helpers::DateHelper.
#
# Released under the MIT license
# Copyright (c) Eiji Sakai <eiji.sakai@softculture.com>
# http://d.hatena.ne.jp/elm200/
# 

PLUGIN_NAME = 'date_helper_ja_' + RAILS_GEM_VERSION.gsub(/\./, '_')
PLUGIN_PATH = File.dirname(__FILE__) + "/lib/" + PLUGIN_NAME + ".rb"
if FileTest.exist?(PLUGIN_PATH)
  require_dependency PLUGIN_NAME if defined? ActionView::Base
else
  require_dependency 'date_helper_ja' if defined? ActionView::Base
end

