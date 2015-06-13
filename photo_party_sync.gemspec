# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'photo_party_sync/version'

Gem::Specification.new do |spec|
  spec.name          = 'photo_party_sync'
  spec.version       = PhotoPartySync::VERSION
  spec.authors       = ['Gerrit Visscher']
  spec.email         = ['gerrit@visscher.de']

  spec.summary       = 'Copies images from wireless sd cards to the local machine'
  # spec.description   = ''
  spec.homepage      = 'https://github.com/kayssun/photo_party_sync'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features)\//) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'nokogiri'
end
