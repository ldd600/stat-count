# -*- encoding: utf-8 -*-

require "rake"
require File.expand_path('../lib/stat-count-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["gavin"]
  gem.email         = ["gavin@ximalya.com"]
  gem.description   = %q{ruby client for stat count server}
  gem.summary       = %q{stat count client}
  gem.homepage      = "http://www.ximalaya.com"
  gem.platform      =  Gem::Platform::RUBY
  gem.files         =  Dir['[A-Z]*'] + Dir['test/**/*'] + Dir['lib/**/*']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stat-count-client"
  gem.require_paths = ["lib", "test"]
  gem.version       = Stat::Count::Client::VERSION

  gem.add_dependency  "hessian2"
end
