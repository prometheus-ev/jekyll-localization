#--
###############################################################################
#                                                                             #
# jekyll-localization -- Jekyll plugin that adds localization features to the #
#                        rendering engine                                     #
#                                                                             #
# Copyright (C) 2010-2011 University of Cologne,                              #
#                         Albertus-Magnus-Platz,                              #
#                         50923 Cologne, Germany                              #
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

  module Localization

    # The language codes that will be considered for translation
    LANGUAGES = %w[en de fr]

    # The language codes mapped to their human names
    HUMAN_LANGUAGES = {
      'en' => %w[English Englisch    Anglais],
      'de' => %w[German  Deutsch     Allemand],
      'fr' => %w[French  Französisch Français]
    }

    # What is considered a language extension
    LANG_EXT_RE = %r{\.([a-z]{2})}

    # The language extension, anchored at the end of the string
    LANG_END_RE = %r{#{Localization::LANG_EXT_RE}\z}

    # Extract relevant parts from a file name
    LANG_PARTS_RE = %r{\A(.*?)#{LANG_EXT_RE}\.(\w+)\z}

    module LocalizedConvertible

      attr_reader :lang

      def self.included(base)
        base.class_eval {
          alias_method :initialize_without_localization, :initialize
          alias_method :initialize, :initialize_with_localization
        }
      end

      private

      # Enhances the original method to extract the language extension.
      def initialize_with_localization(*args)
        initialize_without_localization(*args)

        if @lang = extract_lang(@name)
          data['lang']           = @lang
          data['content_lang'] ||= @lang

          @lang_ext = ".#{@lang}"
        end
      end

      # Extracts language extension from +name+, or all relevant parts
      # if +all+ is true.
      def extract_lang(name, all = false)
        if md = name.match(LANG_PARTS_RE)
          all ? md.captures : md[2]
        else
          all ? [] : nil
        end
      end

      def read_alternate_language_content(base, name)
        basename, lang, ext = extract_lang(name, true)
        return unless lang

        original_data = data  # keep original YAML data!

        (LANGUAGES - [lang]).each { |alternate_lang|
          alternate_name = [basename, alternate_lang, ext].join('.')

          if File.exists?(File.join(base, alternate_name))
            read_yaml(base, alternate_name, false)

            unless content.empty?
              data['content_lang'] = alternate_lang
              break
            end
          end
        }

        data.update(original_data)
      end

    end

    [Page, Post, Layout].each { |klass|
      klass.send(:include, LocalizedConvertible)
    }

  end

  module Convertible

    alias_method :_localization_original_read_yaml, :read_yaml

    # Overwrites the original method to optionally set the content of a
    # file with no content in it to the content of a file with another
    # language which does have content in it.
    def read_yaml(base, name, alt = true)
      _localization_original_read_yaml(base, name)
      read_alternate_language_content(base, name) if alt && content.empty?
    end

  end

  class Page

    alias_method :_localization_original_url, :url

    # Overwrites the original method to include the language extension.
    def url(lang = nil)
      "#{_localization_original_url}#{lang ? '.' + lang : @lang_ext}"
    end

    alias_method :_localization_original_destination, :destination

    # Overwrites the original method to cater for language extension in output
    # file name.
    def destination(dest)
      # The url needs to be unescaped in order to preserve the correct filename
      path = File.join(dest, @dir, CGI.unescape(url))

      if ext == '.html' && _localization_original_url !~ /\.html\z/
        path.sub!(Localization::LANG_END_RE, '')
        File.join(path, "index#{ext}#{@lang_ext}")
      else
        path
      end
    end

    alias_method :_localization_original_process, :process

    # Overwrites the original method to filter the language extension from
    # basename
    def process(name)
      self.ext      = File.extname(name)
      self.basename = name[0 .. -self.ext.length-1].
        sub(Localization::LANG_END_RE, '')
    end

  end

  module Helpers

    def localize_posts(site, page)
      original_posts, lang = site.posts.dup, page.lang
      site.posts.delete_if { |post| post.lang != lang } if lang

      yield
    ensure
      site.posts.replace(original_posts) if original_posts && page.lang
    end

  end

  class Pagination < Generator

    include Helpers

    alias_method :_localization_original_paginate, :paginate

    # Overwrites the original method to prevent double posts.
    def paginate(site, page)
      localize_posts(site, page) { _localization_original_paginate(site, page) }
    end

  end

  module Filters

    include Helpers

    def lang
      if @context.respond_to?(:find_variable, true)
        @context.send(:find_variable, 'page')['lang']
      else
        page.lang
      end
    end

    def other_langs
      Localization::LANGUAGES - [lang]
    end

    def human_lang(lang)
      t(*Localization::HUMAN_LANGUAGES[lang]) || lang.capitalize
    end

    def url_lang(url, lang)
      url.sub(Localization::LANG_END_RE, '.' + lang)
    end

    def local_posts
      localize_posts(@site, @page) { site.posts.dup }
    end

    # call-seq:
    #   t 'default', 'translation', ... => aString (Ruby-style)
    #   'default' | t: 'translation', ... => aString (Liquid-style)
    #
    # Returns the argument whose position corresponds to the current
    # language's position in the Localization::LANGUAGES array. If that
    # particular argument is missing, +default+ is returned.
    def translate(*translations)
      translations.flatten!

      index = Localization::LANGUAGES.index(lang)
      index && translations[index] || translations.first
    end

    alias_method :t, :translate

  end

end
