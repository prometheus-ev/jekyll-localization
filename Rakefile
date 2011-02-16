require File.expand_path(%q{../lib/jekyll/localization/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{jekyll-localization},
      :version      => Jekyll::Localization::VERSION,
      :summary      => %q{Jekyll plugin that adds localization features to the rendering engine.},
      :authors      => ['Jens Wille', 'Arne Eilermann'],
      :email        => ['jens.wille@uni-koeln.de', 'eilermann@lavabit.com'],
      :homepage     => :blackwinter,
      :dependencies => %w[jekyll-rendering]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

begin
  require 'jekyll/testtasks/rake'
rescue LoadError => err
  warn "Please install the `jekyll-testtasks' gem. (#{err})"
end
