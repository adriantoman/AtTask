# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "attask/version"

Gem::Specification.new do |s|
  s.name        = "attask"
  s.version     = Attask::VERSION
  s.authors     = ["Adrian Toman"]
  s.email       = ["adrian.toman@gmail.com"]
  s.homepage    = ""
  s.summary     = "API connector for AtTask API"
  s.description = ""

  s.rubyforge_project = "attask"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "httparty"
  s.add_dependency "hashie"
  s.add_dependency "json"
  s.add_dependency "ext"
  s.add_dependency "chronic"
  s.add_dependency "activesupport"
  a.add_dependency 'os'
end
