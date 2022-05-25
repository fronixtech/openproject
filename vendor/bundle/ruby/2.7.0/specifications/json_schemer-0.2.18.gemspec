# -*- encoding: utf-8 -*-
# stub: json_schemer 0.2.18 ruby lib

Gem::Specification.new do |s|
  s.name = "json_schemer".freeze
  s.version = "0.2.18"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Harsha".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-02-27"
  s.email = ["davishmcclurg@gmail.com".freeze]
  s.homepage = "https://github.com/davishmcclurg/json_schemer".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "JSON Schema validator. Supports drafts 4, 6, and 7.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_runtime_dependency(%q<ecma-re-validator>.freeze, ["~> 0.3"])
    s.add_runtime_dependency(%q<hana>.freeze, ["~> 1.3"])
    s.add_runtime_dependency(%q<uri_template>.freeze, ["~> 0.7"])
    s.add_runtime_dependency(%q<regexp_parser>.freeze, ["~> 2.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<ecma-re-validator>.freeze, ["~> 0.3"])
    s.add_dependency(%q<hana>.freeze, ["~> 1.3"])
    s.add_dependency(%q<uri_template>.freeze, ["~> 0.7"])
    s.add_dependency(%q<regexp_parser>.freeze, ["~> 2.0"])
  end
end
