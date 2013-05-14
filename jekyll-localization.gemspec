# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jekyll-localization"
  s.version = "0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille", "Arne Eilermann"]
  s.date = "2013-05-14"
  s.description = "Jekyll plugin that adds localization features to the rendering engine."
  s.email = ["jens.wille@gmail.com", "eilermann@lavabit.com"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/jekyll/localization.rb", "lib/jekyll/localization/version.rb", "COPYING", "ChangeLog", "README", "Rakefile"]
  s.homepage = "http://github.com/blackwinter/jekyll-localization"
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "jekyll-localization Application documentation (v0.1.7)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Jekyll plugin that adds localization features to the rendering engine."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll-rendering>, [">= 0"])
    else
      s.add_dependency(%q<jekyll-rendering>, [">= 0"])
    end
  else
    s.add_dependency(%q<jekyll-rendering>, [">= 0"])
  end
end
