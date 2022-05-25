# -*- encoding: utf-8 -*-
# stub: awesome_nested_set 3.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "awesome_nested_set".freeze
  s.version = "3.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brandon Keepers".freeze, "Daniel Morrison".freeze, "Philip Arndt".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIEMjCCApqgAwIBAgIBATANBgkqhkiG9w0BAQsFADAjMSEwHwYDVQQDDBhnZW1z\nL0RDPXAvREM9YXJuZHQvREM9aW8wHhcNMjEwNjIzMDkyNzU2WhcNMjIwNjIzMDky\nNzU2WjAjMSEwHwYDVQQDDBhnZW1zL0RDPXAvREM9YXJuZHQvREM9aW8wggGiMA0G\nCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQD0CYnD37uLlJ3Urla2EnnUQ8S6s16k\nAGMpAzpmARo8YwSqtYMJVGyBzUeI7y93Fk9ncswhIFSH/hnh/Ouat/ki9flHlZ+w\nanv0M+9v3wCLyZSC5BQIWpoduFM/fuvLoDUJDWxL50RjwMS0qo2x2LvfQdHN8gn3\nJdSIV5WLJKIvlmIl9S3pw0JO5KRUGn1PcBO7C0S0SlbhVjRHtlao1ycWUULsX109\nhCh39MPGtnZpdCcxheh0TH/UA/jV0/du9/rQdoidkNHkaC24pPfBJ3nS+rAbWaHP\nWmP+0rjfk/XnGBu/HZpKvlnwQjP3QdK4UMtWl8zewqFMNcIiBRALQugnL/SfrP/4\nCSlha9LwkiE6ByeY4WGnNjNqpi5J3IzjEkZRAxG7u9gCB3FzTaBTyXZYI6jplYNw\nTcCJIBHuoPaa+m9brpjb3Uv94nfM97ZP+OmpGYCCAMq4TT7OOV+t8wJc0w8bb0FO\nROhmVNTxrBaNcl6MkZn88EMRCsGgoWklOG0CAwEAAaNxMG8wCQYDVR0TBAIwADAL\nBgNVHQ8EBAMCBLAwHQYDVR0OBBYEFGu7pbmeILyHnBmannuaNRfdN8MsMBoGA1Ud\nEQQTMBGBD2dlbXNAcC5hcm5kdC5pbzAaBgNVHRIEEzARgQ9nZW1zQHAuYXJuZHQu\naW8wDQYJKoZIhvcNAQELBQADggGBANlxc4uAnkPC3zbztG7uZfBfn4HSuvv655Pa\nUaYZ6hNETFrqg78mGs3PkFe2Ru7cVWwckbmH46aq50QoNnx4ClxT03vr03n76Jg1\n8WWHkf0+rcINFlbtIFcmcFrois5Ow3n7pH+xstDtzoWcbh41WwuZStNhrIYsnjAK\n/ovz8D5JlboxceOpVLB/0NiqNEWltK+EMQHmX25Sqf/r5o5rAL9zwEKPFp1Y5X+z\nt2jBjYt2ymr1eMWxux6e+N2uKZL4MblHawxvKlI8UHsIiV9xrc4BwlwlbitcvNIL\nZykdSlpTJd0Guy92iYjCJMC09tMRUNxiVBwD3jRGSeW9YAPIZGXIcVlm6srIRDjJ\no8wB6oOvHAkRXnntOo/4bBDH+ehmgvhh/O/mI+au6C0M430fv+ooH0w08LEXLx1k\ne17ZNASZffbQRP09MH2GZ2AOlkildTX6looWRforZEZi+qamognrozd3MI5QHi1W\nUAZUzHLrrFu7gnkFvLVpxOUf4ItOkA==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2022-02-08"
  s.description = "An awesome nested set implementation for Active Record".freeze
  s.email = "info@collectiveidea.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "https://github.com/collectiveidea/awesome_nested_set".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze, "--inline-source".freeze, "--line-numbers".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.2.33".freeze
  s.summary = "An awesome nested set implementation for Active Record".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 4.0.0", "< 7.1"])
    s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_development_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-nav>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 4.0.0"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 4.0.0", "< 7.1"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<pry-nav>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 4.0.0"])
  end
end
