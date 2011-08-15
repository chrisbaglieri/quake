# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "quake/version"

Gem::Specification.new do |s|
  s.name        = "quake"
  s.version     = Quake::VERSION
  s.authors     = ["Chris Baglieri"]
  s.email       = ["chris.baglieri@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "quake"
  
  spec.add_dependency('curb', '>= 0.7.15')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
