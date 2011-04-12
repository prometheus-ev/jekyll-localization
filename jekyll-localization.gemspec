# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jekyll-localization}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille", "Arne Eilermann"]
  s.date = %q{2011-04-12}
  s.description = %q{Jekyll plugin that adds localization features to the rendering engine.}
  s.email = ["jens.wille@uni-koeln.de", "eilermann@lavabit.com"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/jekyll/localization.rb", "lib/jekyll/localization/version.rb", "README", "ChangeLog", "Rakefile", "COPYING"]
  s.homepage = %q{http://github.com/blackwinter/jekyll-localization}
  s.rdoc_options = ["--charset", "UTF-8", "--title", "jekyll-localization Application documentation (v0.1.1)", "--main", "README", "--line-numbers", "--all"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Jekyll plugin that adds localization features to the rendering engine.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll-rendering>, [">= 0"])
    else
      s.add_dependency(%q<jekyll-rendering>, [">= 0"])
    end
  else
    s.add_dependency(%q<jekyll-rendering>, [">= 0"])
  end
end
