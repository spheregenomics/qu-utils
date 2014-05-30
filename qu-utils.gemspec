# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qu/utils/version'

Gem::Specification.new do |spec|
  spec.name          = "qu-utils"
  spec.version       = Qu::Utils::VERSION
  spec.authors       = ["Wubin Qu"]
  spec.email         = ["quwubin@gmail.com"]
  spec.description   = %q{Useful class or methods used in qu-* projects.}
  spec.summary       = %q{Utils by Wubin Qu}
  spec.homepage      = "https://github.com/quwubin/qu-utils"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'bio', '>= 1.4'
  spec.add_runtime_dependency 'os', '~> 0.9.6'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
