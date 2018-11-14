source 'http://rubygems.org'

gem 'rails', '~> 3.2.21'

group :assets do
  gem 'sass-rails', '>= 3.2.5'
  gem 'coffee-rails', '>= 3.2.2'
  gem 'uglifier'
end

platforms :ruby do
  gem 'mysql2', '~> 0.3.11'
  gem 'pg', '>= 0.9.0'
  gem 'sqlite3'
  gem 'therubyracer'
end

gem 'haml-rails', '>= 0.4'
gem 'jquery-rails', '>= 2.1.3'
gem 'will_paginate', '~> 3.0.4'
gem "audited-activerecord", "~> 3.0.0.0"
gem 'inherited_resources', '>= 1.3.1'
gem 'devise', '~> 2.2.8'
gem "devise-encryptable", ">= 0.1.1"
gem 'rabl', '>= 0.7.6'
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

  gem "cucumber-rails", :require => false
  gem 'mocha', :require => false
  gem 'webrat'
  gem 'database_cleaner'
end
