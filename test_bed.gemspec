# -*- encoding: utf-8 -*-
require File.expand_path('../lib/test_bed/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["TheHamon"]
  gem.email         = ["example@example.com"]
  gem.description   = %q{ The gem is intended to simplify developer's live when dealing with pivotal tracker (PT) and git. }
  gem.summary       = %q{ }
  gem.homepage      = ""

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "aruba"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency "factory_girl"

  gem.add_runtime_dependency "grit"
  gem.add_runtime_dependency "pivotal-tracker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "test_bed"
  gem.require_paths = ["lib"]
  gem.version       = TestBed::VERSION
end
