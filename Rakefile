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
      :dependencies => %w[jekyll-rendering]
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
end

### Place your custom Rake tasks here.

require 'jekyll/testtasks'
