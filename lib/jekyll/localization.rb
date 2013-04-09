# encoding: utf-8

#--
###############################################################################
#                                                                             #
# jekyll-localization -- Jekyll plugin that adds localization features to the #
#                        rendering engine                                     #
#                                                                             #
# Copyright (C) 2010-2012 University of Cologne,                              #
#                         Albertus-Magnus-Platz,                              #
#                         50923 Cologne, Germany                              #
#                                                                             #
# Copyright (C) 2013 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# jekyll-localization is free software; you can redistribute it and/or modify #
# it under the terms of the GNU Affero General Public License as published by #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# jekyll-localization is distributed in the hope that it will be useful, but  #
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public      #
# License for more details.                                                   #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with jekyll-localization. If not, see <http://www.gnu.org/licenses/>. #
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

    # Path to I18n locale files (*.yml).
    I18N_LOCALES = ENV['I18N_LOCALES'] || File.join(begin
      [Gem::Specification.find_by_name('rails-i18n').gem_dir, 'rails']
    rescue LoadError
      __FILE__.chomp('.rb')
    end, 'locale')

    # Cache for I18n locale information.
    I18N = Hash.new { |h, k|
      h[k] = YAML.load_file(File.join(I18N_LOCALES, "#{k}.yml"))[k] rescue nil
    }

    class << self

      private

      def i18n(key)  # :nodoc:
        key = key.split('.')

        Hash.new { |h, k| h[k] = key.inject(I18N[k]) { |i, j|
          if (v = i[j]).is_a?(Hash) then v else break v end
        } }
      end

    end

    TIME_FMT = i18n('time.formats.default').update(
      'en' => '%a %-d %b %Y %H:%M:%S %p %Z',
      'de' => '%a %-d %b %Y %H:%M:%S %Z'
    )

    # For backwards compatibility.
    DATE_FMT = TIME_FMT

    DATE_FMT_LONG = i18n('date.formats.long').update(
      'en' => '%-d %B %Y',
      'de' => '%-d. %B %Y'
    )

    DATE_FMT_SHORT = i18n('date.formats.short').update(
      'en' => '%-d %b %Y',
      'de' => '%-d. %b %Y'
    )

    MONTHNAMES      = i18n('date.month_names')
    ABBR_MONTHNAMES = i18n('date.abbr_month_names')
    DAYNAMES        = i18n('date.day_names')
    ABBR_DAYNAMES   = i18n('date.abbr_day_names')

    MERIDIAN = Hash.new { |h, k|
      h[k] = %w[am pm].map { |i| i18n("time.#{i}")[k] }
    }.update(
      'en' => %w[AM PM]
    )

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

    def localized_posts(posts, page, only = false)
      lang = page.lang
      lang ? posts.select { |post| post.lang == lang } : only ? nil : posts
    end

    def localize_posts(site, page)
      s = site.respond_to?(:set_payload)

      o = s ? site.get_payload('posts') : site.posts.dup
      l = localized_posts(o, page, true)

      s ? site.set_payload('posts' => l) : site.posts.replace(l) if l

      yield
    ensure
      s ? site.set_payload('posts' => o) : site.posts.replace(o) if l
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

    def human_lang(lang = lang)
      translate(*Localization::HUMAN_LANGUAGES[lang]) || lang.capitalize
    end

    def native_lang(lang = lang)
      translate_lang(lang, *Localization::HUMAN_LANGUAGES[lang]) || lang.capitalize
    end

    def url_lang(url, lang = lang)
      url = url.sub(Localization::LANG_END_RE, '')
      url << '.' << lang if lang
      url
    end

    def local_posts
      localized_posts(@site.posts, @page)
    end

    # call-seq:
    #   t 'default', 'translation', ... => aString (Ruby-style with array)
    #   'default' | t: 'translation', ... => aString (Liquid-style with array)
    #   t 'en' => 'default', 'de' => 'translation', ... => aString (Ruby-style with hash)
    #   { 'en' => 'default', 'de' => 'translation', ... } | t => aString (Liquid-style with hash)
    #
    # If array given, returns the argument whose position corresponds to
    # the current language's position in the Localization::LANGUAGES array.
    # If that particular argument is missing, +default+ is returned.
    #
    # If hash given, returns the value for the current language. If that
    # particular value is missing, the value for the default language is
    # returned.
    def translate(*translations)
      translate_lang(lang, *translations)
    end

    alias_method :t, :translate

    def translate_lang(lang, *translations)
      translations.flatten!

      if translations.last.is_a?(Hash)
        hash = translations.pop

        if translations.empty?
          hash[key = lang] || hash[key.to_sym] ||
          hash[key = Localization::LANGUAGES.first] || hash[key.to_sym]
        else
          raise ArgumentError, 'both hash and array given'
        end
      else
        index = Localization::LANGUAGES.index(lang)
        index && translations[index] || translations.first
      end
    end

    alias_method :tl, :translate_lang

    alias_method :_localization_original_date_to_string, :date_to_string

    # Overwrites the original method to generate localized date strings.
    def date_to_string(date, lang = lang)
      local_date_string(date, Localization::DATE_FMT_SHORT[lang], lang)
    end

    alias_method :_localization_original_date_to_long_string, :date_to_long_string

    # Overwrites the original method to generate localized date strings.
    def date_to_long_string(date, lang = lang)
      local_date_string(date, Localization::DATE_FMT_LONG[lang], lang)
    end

    def local_date_string(date, fmt, lang = lang)
      # unabashedly stole this snippet from Joshua Harvey's Globalize plugin,
      # which itself unabashedly stole it from Tadayoshi Funaba's Date class
      res = ''

      fmt.scan(/%[EO]?(.)|(.)/) { |a, b|
        res << case a
          when nil then b
          when 'A' then Localization::DAYNAMES[lang][date.wday]
          when 'a' then Localization::ABBR_DAYNAMES[lang][date.wday]
          when 'B' then Localization::MONTHNAMES[lang][date.month]
          when 'b' then Localization::ABBR_MONTHNAMES[lang][date.month]
          when 'c' then local_date_string(date, Localization::TIME_FMT[lang], lang)
          when 'P' then Localization::MERIDIAN[lang][date.send(:hour) < 12 ? 0 : 1].downcase
          when 'p' then Localization::MERIDIAN[lang][date.send(:hour) < 12 ? 0 : 1]
          else '%' << a
        end
      } if fmt

      date.strftime(res)
    end

  end

end
