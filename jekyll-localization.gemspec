# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jekyll-localization}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jens Wille}, %q{Arne Eilermann}]
  s.date = %q{2011-05-31}
  s.description = %q{Jekyll plugin that adds localization features to the rendering engine.}
  s.email = [%q{jens.wille@uni-koeln.de}, %q{eilermann@lavabit.com}]
  s.extra_rdoc_files = [%q{README}, %q{COPYING}, %q{ChangeLog}]
  s.files = [%q{lib/jekyll/localization/version.rb}, %q{lib/jekyll/localization.rb}, %q{Rakefile}, %q{COPYING}, %q{ChangeLog}, %q{README}]
  s.homepage = %q{http://github.com/blackwinter/jekyll-localization}
  s.rdoc_options = [%q{--line-numbers}, %q{--title}, %q{jekyll-localization Application documentation (v0.1.3)}, %q{--main}, %q{README}, %q{--charset}, %q{UTF-8}, %q{--all}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.4}
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
