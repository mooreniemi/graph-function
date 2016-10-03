# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graph/function/version'

Gem::Specification.new do |spec|
  spec.name          = 'graph-function'
  spec.version       = Graph::Function::VERSION
  spec.authors       = ['Alex Moore-Niemi', 'Cora Johnson-Roberson']
  spec.email         = ['moore.niemi@gmail.com']

  spec.summary       = %q{Graph function performance.}
  spec.description   = %q{Using gnuplot and Ruby's benchmarking abilities, see the asymptotic behavior of your functions graphed.}
  spec.homepage      = 'http://github.com/mooreniemi/graph-function'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.add_dependency 'gnuplot'
  spec.add_dependency 'rantly'
  spec.add_dependency 'faker'
  spec.add_dependency 'ruby-progressbar'
  spec.add_dependency 'benchmark-memory'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
