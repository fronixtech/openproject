# -*- encoding: utf-8 -*-
# stub: dalli 3.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "dalli".freeze
  s.version = "3.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Peter M. Goldstein".freeze, "Mike Perham".freeze]
  s.date = "2022-02-14"
  s.description = "High performance memcached client for Ruby".freeze
  s.email = ["peter.m.goldstein@gmail.com".freeze, "mperham@gmail.com".freeze]
  s.homepage = "https://github.com/petergoldstein/dalli".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6".freeze)
  s.rubygems_version = "3.2.33".freeze
  s.summary = "High performance memcached client for Ruby".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<connection_pool>.freeze, [">= 0"])
    s.add_development_dependency(%q<rack>.freeze, ["~> 2.0", ">= 2.2.0"])
    s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-minitest>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<connection_pool>.freeze, [">= 0"])
    s.add_dependency(%q<rack>.freeze, ["~> 2.0", ">= 2.2.0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-minitest>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-rake>.freeze, [">= 0"])
  end
end
