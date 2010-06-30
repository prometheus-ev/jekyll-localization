#--
###############################################################################
#                                                                             #
# jekyll-localization -- Jekyll plugin that adds localization features to the #
#                        rendering engine                                     #
#                                                                             #
# Copyright (C) 2010 University of Cologne,                                   #
#                    Albertus-Magnus-Platz,                                   #
#                    50923 Cologne, Germany                                   #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# jekyll-localization is free software; you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by the    #
# Free Software Foundation; either version 3 of the License, or (at your      #
# option) any later version.                                                  #
#                                                                             #
# jekyll-localization is distributed in the hope that it will be useful, but  #
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with jekyll-localization. If not, see <http://www.gnu.org/licenses/>.       #
#                                                                             #
###############################################################################
#++

require 'cgi'
require 'jekyll/rendering'

module Jekyll

  LANGUAGES = %w[en de fr]

  module Localization
  end

  class Page

    alias_method :_localization_original_initialize, :initialize

    def initialize(site, base, dir, name)
      _localization_original_initialize(site, base, dir, name)

      @lang = data['lang'] = @name[/\.([a-z]{2})\.\w+\z/, 1]
    end

    alias_method :_localization_original_url, :url

    def url
      @lang ? "#{_localization_original_url}.#{@lang}" : _localization_original_url
    end

    alias_method :_localization_original_write, :write

    def write(dest_prefix, dest_suffix = nil)
      dest = File.join(dest_prefix, @dir)
      dest = File.join(dest, dest_suffix) if dest_suffix
      FileUtils.mkdir_p(dest)

      # The url needs to be unescaped in order to preserve the correct filename
      path = File.join(dest, CGI.unescape(url))
      if ext == '.html' && url !~ /\.html(?:\.[a-z]{2})?\z/
        FileUtils.mkdir_p(path)
        path = File.join(path, "index#{@lang ? "#{ext}.#{@lang}" : ext}")
      end

      File.open(path, 'w') { |f| f.write(output) }
    end

  end

  module Engine

    class Erb

      def t(*translations)
        index = LANGUAGES.index(page.lang)
        index && translations[index] || translations.first
      end

    end

  end

  class TranslateTag < Liquid::Tag

    # FIXME: dunno if it works...

    def initialize(tag_name, translations, tokens)
      super
      @translations = translations
    end

    def render(context)
      index = LANGUAGES.index(context.registers[:page].lang)
      index && @translations[index] || @translations.first
    end

    Liquid::Template.register_tag('t', self)

  end

end
