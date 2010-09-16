require %q{lib/jekyll/localization/version}

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{jekyll-localization},
      :version      => Jekyll::Localization::VERSION,
      :summary      => %q{Jekyll plugin that adds localization features to the rendering engine.},
      :files        => FileList['lib/**/*.rb'].to_a,
      :extra_files  => FileList['[A-Z]*'].to_a,
      :dependencies => %w[jekyll-rendering],
      :authors      => ["Jens Wille"],
      :email        => %q{jens.wille@uni-koeln.de}
    }
  }}
rescue LoadError
  warn "Please install the `hen' gem."
end

### Place your custom Rake tasks here.

begin
  require 'jekyll/testtasks/rake'
rescue LoadError
  warn "Please install the `jekyll-testtasks' gem."
end
