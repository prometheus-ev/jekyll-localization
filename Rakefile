require %q{lib/jekyll/localization/version}

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{jekyll-localization},
      :version      => Jekyll::Localization::VERSION,
      :summary      => %q{Jekyll plugin that adds localization features to the rendering engine.},
      :authors      => ['Jens Wille', 'Arne Eilermann'],
      :email        => ['jens.wille@uni-koeln.de', 'eilermann@lavabit.com'],
      :homepage     => 'http://github.com/blackwinter/jekyll-localization',
      :files        => FileList['lib/**/*.rb'].to_a,
      :extra_files  => FileList['[A-Z]*'].to_a,
      :dependencies => %w[jekyll-rendering]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

### Place your custom Rake tasks here.

begin
  require 'jekyll/testtasks/rake'
rescue LoadError => err
  warn "Please install the `jekyll-testtasks' gem. (#{err})"
end
