# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mram-eveapi"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Markus Rambossek"]
  s.date = "2012-08-19"
  s.description = "EVE API Interface Layer"
  s.email = "git@rambossek.at"
  s.extra_rdoc_files = ["README.md", "lib/mram-eveapi.rb"]
  s.files = ["README.md", "Rakefile", "init.rb", "lib/mram-eveapi.rb", "Manifest", "mram-eveapi.gemspec"]
  s.homepage = "https://github.com/mrambossek/mram-eveapi"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Mram-eveapi", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "mram-eveapi"
  s.rubygems_version = "1.8.11"
  s.summary = "EVE API Interface Layer"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpclient>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<httpclient>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<httpclient>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
