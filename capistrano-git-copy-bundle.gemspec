# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/git_copy/bundle/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-git-copy-bundle'
  spec.version       = Capistrano::GitCopy::Bundle::VERSION
  spec.authors       = ['Florian Schwab']
  spec.email         = ['me@ydkn.de']

  spec.summary       = %q{Packages gems locally and uploads them to the remote server instead of fetching them on the remote server.}
  spec.description   = %q{Packages gems locally and uploads them to the remote server instead of fetching them on the remote server.}
  spec.homepage      = 'https://github.com/ydkn/capistrano-git-copy-bundle'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler',             '~> 1.9'
  spec.add_dependency 'capistrano-bundler',  '~> 1.1'
  spec.add_dependency 'capistrano-git-copy', '~> 1.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
end
