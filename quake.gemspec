# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "quake/version"

Gem::Specification.new do |s|
  s.name        = "quake"
  s.version     = Quake::VERSION
  s.authors     = ["Chris Baglieri"]
  s.email       = ["chris.baglieri@gmail.com"]
  s.homepage    = "https://github.com/chrisbaglieri/quake"
  s.description = %q{A library exposing the U.S. Geological Survey's real-time earthquake data}
  s.summary     = s.description

  s.add_dependency('curb', '>= 0.7.15')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- tests/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
