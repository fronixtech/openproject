# -*- encoding: utf-8 -*-
# stub: dalli 3.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "dalli".freeze
  s.version = "3.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Peter M. Goldstein".freeze, "Mike Perham".freeze]
  s.date = "2021-10-27"
  s.description = "High performance memcached client for Ruby".freeze
  s.email = ["peter.m.goldstein@gmail.com".freeze, "mperham@gmail.com".freeze]
  s.homepage = "https://github.com/petergoldstein/dalli".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "High performance memcached client for Ruby".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rack>.freeze, [">= 0"])
    s.add_development_dependency(%q<connection_pool>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rack>.freeze, [">= 0"])
    s.add_dependency(%q<connection_pool>.freeze, [">= 0"])
  end
end
