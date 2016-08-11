[![Build Status](https://travis-ci.org/wojw5/capistrano-jira.svg?branch=master)](https://travis-ci.org/wojw5/capistrano-jira)
[![Code Climate](https://codeclimate.com/github/wojw5/capistrano-jira/badges/gpa.svg)](https://codeclimate.com/github/wojw5/capistrano-jira)
# Capistrano::Jira

Transit JIRA issues automatically after deployment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-jira'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-jira

## Usage

- Require library in `Capfile`
```ruby
require 'capistrano/jira'
```

- Set general parameters in `config/deploy.rb`
```ruby
set :jira_username,    'john.doe@exalmple.com' # default: ENV['CAPISTRANO_JIRA_USERNAME']
set :jira_password,    'p@55w0rD' # default: ENV['CAPISTRANO_JIRA_PASSWORD']
set :jira_site,        'https://example.atlassian.net' # default: ENV['CAPISTRANO_JIRA_SITE']
set :jira_project_key, 'PROJ' # required
```

- Set parameters for specific environment (for example `config/deploy/staging.rb`)
```ruby
set :jira_status_name,     'QA passed' # required; name of status from which issues should be transited
set :jira_transition_name, 'Deploy to staging' # required; name of transition that should be executed
set :jira_filter_jql,      'component = Backend' # optional; additional JQL filter to scope issues
```

Then while running deployment you should see transitioned issues.

When transition fails for some reason (for example HTTP Error) it will inform you but NOT fail whole deployment.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-jira.
