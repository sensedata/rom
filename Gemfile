source 'https://rubygems.org'

gemspec

group :console do
  gem 'pry'
  gem 'pg', platforms: [:mri]
end

group :test do
  gem 'virtus'
  gem 'anima', '~> 0.2.0'
  gem 'minitest'
  gem 'thread_safe'
  gem 'activesupport'
  gem 'inflecto', '~> 0.0', '>= 0.0.2'

  platforms :rbx do
    gem 'rubysl-bigdecimal', platforms: :rbx
    gem 'codeclimate-test-reporter', require: false
  end
end

group :sql do
  gem 'rom-sql', github: 'rom-rb/rom-sql', branch: 'master'
  gem 'sequel'
  gem 'jdbc-sqlite3', platforms: :jruby
  gem 'sqlite3', platforms: [:mri, :rbx]
end

group :benchmarks do
  gem 'activerecord', '4.2.0'
  gem 'benchmark-ips', '~> 2.2.0'
end

group :tools do
  gem 'rubocop', '~> 0.31'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'

  gem 'byebug', platform: :mri

  platform :mri do
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
