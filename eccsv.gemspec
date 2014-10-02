# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eccsv/version'

Gem::Specification.new do |spec|
  spec.name          = "eccsv"
  spec.version       = ECCSV::VERSION
  spec.authors       = ["Jeremy Stephens"]
  spec.email         = ["jeremy.f.stephens@vanderbilt.edu"]
  spec.description   = %q{CSV library with advanced error reporting}
  spec.summary       = %q{CSV library with advanced error reporting}
  spec.homepage      = "https://github.com/coupler/eccsv"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "racc"
end
