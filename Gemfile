source 'http://rubygems.org'

gem 'rails', '~> 5.0.0'

group :assets do
  gem 'sass-rails', '>= 5.0.5'
  gem 'coffee-rails', '>= 4.1.1'
  gem 'uglifier'
end

platforms :ruby do
  gem 'mysql2', '~> 0.3.11'
  gem 'pg', '>= 0.9.0'
  gem 'sqlite3'
  gem 'therubyracer'
end

gem 'haml-rails', '>= 0.5.3'
gem 'jquery-rails', '>= 4.0.1'
gem 'will_paginate', '~> 3.0.4'
gem "audited-activerecord", "~> 3.0.0.rc2"
gem 'inherited_resources', '>= 1.6.0'
gem 'devise', '~> 4.0.0'
gem "devise-encryptable", ">= 0.1.1"
gem 'rabl'
gem 'state_machine'

gem 'acts_as_list'
gem 'dynamic_form'

group :development do
  gem 'debugger', :platform => :mri_19
  #gem 'RedCloth', '>= 4.1.1'
end

group :development, :test do
  gem "rspec-rails", ">= 2.13.0"
  gem 'RedCloth', '>= 4.1.1'
end

group :test do
  gem "factory_girl_rails", "~> 4.2", ">= 4.2.1"

  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem 'mocha', :require => false
  gem 'webrat', '>= 0.7.3'
  gem 'database_cleaner'
end
