# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{antir-engine}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fernando Alonso"]
  s.date = %q{2011-09-09}
  s.description = %q{AntirEngine VPSs configuration interface}
  s.email = %q{krakatoa1987@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "antir.gemspec",
    "lib/antir.rb",
    "lib/antir/hypervisor/domain_handler.rb",
    "lib/antir/hypervisor_handler.rb",
    "lib/antir/server.rb",
    "lib/antir/vps.rb",
    "lib/antir/vps/xml.rb",
    "test/helper.rb",
    "test/test_antir.rb"
  ]
  s.homepage = %q{http://github.com/krakatoa/antir-engine}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{AntirEngine configuration tool}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<beanstalk-client>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<bson>, [">= 1.3.1"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 1.3.1"])
      s.add_runtime_dependency(%q<zmq>, [">= 2.1.3"])
      s.add_runtime_dependency(%q<libxml-ruby>, [">= 1.1.4"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<beanstalk-client>, [">= 1.1.0"])
      s.add_dependency(%q<bson>, [">= 1.3.1"])
      s.add_dependency(%q<bson_ext>, [">= 1.3.1"])
      s.add_dependency(%q<zmq>, [">= 2.1.3"])
      s.add_dependency(%q<libxml-ruby>, [">= 1.1.4"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<beanstalk-client>, [">= 1.1.0"])
    s.add_dependency(%q<bson>, [">= 1.3.1"])
    s.add_dependency(%q<bson_ext>, [">= 1.3.1"])
    s.add_dependency(%q<zmq>, [">= 2.1.3"])
    s.add_dependency(%q<libxml-ruby>, [">= 1.1.4"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
