require_relative 'lib/transparam/version'

Gem::Specification.new do |spec|
  spec.name          = 'transparam'
  spec.version       = Transparam::VERSION
  spec.authors       = ['Benjamin Wood']
  spec.email         = ['ben@hint.io']

  spec.summary       = 'Migrate from protected_attributes -> strong_parameters'
  spec.description   = 'Migrate to strong_parameters with ease'
  spec.homepage      = 'https://github.com/hintmedia/transparam'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hintmedia/transparam'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '~> 4.2'
  spec.add_runtime_dependency 'parser'
  spec.add_runtime_dependency 'protected_attributes'
  spec.add_runtime_dependency 'rufo'
  spec.add_runtime_dependency 'thor', '~> 1.0.0'
  spec.add_runtime_dependency 'unparser'

  spec.add_development_dependency 'simplecov'
end
