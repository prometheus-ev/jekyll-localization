# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jekyll-localization}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille", "Arne Eilermann"]
  s.date = %q{2010-09-29}
  s.description = %q{Jekyll plugin that adds localization features to the rendering engine.}
  s.email = ["jens.wille@uni-koeln.de", "eilermann@lavabit.com"]
  s.extra_rdoc_files = ["COPYING", "ChangeLog", "README"]
  s.files = ["lib/jekyll/localization.rb", "lib/jekyll/localization/version.rb", "README", "ChangeLog", "Rakefile", "COPYING"]
  s.homepage = %q{http://github.com/blackwinter/jekyll-localization}
  s.rdoc_options = ["--title", "jekyll-localization Application documentation", "--main", "README", "--line-numbers", "--inline-source", "--all", "--charset", "UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Jekyll plugin that adds localization features to the rendering engine.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
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
