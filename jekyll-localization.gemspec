# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jekyll-localization"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille", "Arne Eilermann"]
  s.date = "2012-04-18"
  s.description = "Jekyll plugin that adds localization features to the rendering engine."
  s.email = ["jens.wille@uni-koeln.de", "eilermann@lavabit.com"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/jekyll/localization/version.rb", "lib/jekyll/localization.rb", "ChangeLog", "COPYING", "README", "Rakefile"]
  s.homepage = "http://github.com/blackwinter/jekyll-localization"
  s.rdoc_options = ["--main", "README", "--charset", "UTF-8", "--all", "--title", "jekyll-localization Application documentation (v0.1.4)", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.22"
  s.summary = "Jekyll plugin that adds localization features to the rendering engine."

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
