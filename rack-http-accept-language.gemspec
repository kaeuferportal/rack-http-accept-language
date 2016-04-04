# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name = 'rack-http-accept-language'
  s.version = '0.1.0'

  if s.respond_to? :required_rubygems_version=
    s.required_rubygems_version = Gem::Requirement.new('>= 1.2')
  end
  s.required_ruby_version = '>= 2.1.0'
  s.author = 'Bennet Palluthe'
  s.email = 'bennet.palluthe@kaeuferportal.de'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4.8'
  s.add_development_dependency 'pry', '~> 0.10.3'
  s.add_development_dependency 'rack-test', '~> 0.6.3'
  s.add_development_dependency 'rubocop', '~> 0.38.0'
  s.add_development_dependency 'i18n', '~> 0.7.0'

  s.rubygems_version = '2.6.2'
  s.summary = 'http accept language handler'
  s.description = 'http accept language handler'
  s.homepage = 'https://github.com/kaeuferportal/rack-http-accept-language'
end
