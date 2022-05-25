# -*- encoding: utf-8 -*-
# stub: openproject-translations 7.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "openproject-translations".freeze
  s.version = "7.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["OpenProject GmbH".freeze]
  s.date = "2022-02-23"
  s.description = "Adds translations to OpenProject.".freeze
  s.email = "info@openproject.com".freeze
  s.files = ["README.md".freeze, "config/locales/plurals.rb".freeze, "doc/CHANGELOG.md".freeze, "doc/COPYRIGHT.md".freeze, "doc/COPYRIGHT_short.md".freeze, "doc/GPL.txt".freeze, "lib/open_project/translations".freeze, "lib/open_project/translations.rb".freeze, "lib/open_project/translations/engine.rb".freeze, "lib/open_project/translations/pluralization_backend.rb".freeze, "lib/open_project/translations/version.rb".freeze, "lib/openproject-translations.rb".freeze]
  s.licenses = ["GPLv3".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "OpenProject Translations".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<crowdin-api>.freeze, ["~> 0.6.0"])
    s.add_runtime_dependency(%q<mixlib-shellout>.freeze, ["~> 2.1.0"])
    s.add_runtime_dependency(%q<rubyzip>.freeze, [">= 0"])
  else
    s.add_dependency(%q<crowdin-api>.freeze, ["~> 0.6.0"])
    s.add_dependency(%q<mixlib-shellout>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<rubyzip>.freeze, [">= 0"])
  end
end
