# -*- encoding: utf-8 -*-
# stub: puma-plugin-statsd 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "puma-plugin-statsd".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["James Healy".freeze]
  s.date = "2021-12-04"
  s.email = "james@yob.id.au".freeze
  s.executables = ["statsd-to-stdout".freeze]
  s.files = ["bin/statsd-to-stdout".freeze]
  s.homepage = "https://github.com/yob/puma-plugin-statsd".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Send puma metrics to statsd via a background thread".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<puma>.freeze, [">= 5.0", "< 6"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_development_dependency(%q<sinatra>.freeze, [">= 0"])
    s.add_development_dependency(%q<rack>.freeze, [">= 0"])
  else
    s.add_dependency(%q<puma>.freeze, [">= 5.0", "< 6"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<sinatra>.freeze, [">= 0"])
    s.add_dependency(%q<rack>.freeze, [">= 0"])
  end
end
