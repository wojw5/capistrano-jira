[![Code Climate](https://codeclimate.com/github/wojw5/capistrano-jira/badges/gpa.svg)](https://codeclimate.com/github/wojw5/capistrano-jira)
# Capistrano::Jira

Update JIRA issues automatically after deployment.

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
set :jira_username,                 'john.doe@exalmple.com' # default: ENV['CAPISTRANO_JIRA_USERNAME']
set :jira_password,                 'p@55w0rD' # default: ENV['CAPISTRANO_JIRA_PASSWORD']
set :jira_site,                     'https://example.atlassian.net' # default: ENV['CAPISTRANO_JIRA_SITE']
set :jira_project_key,              'PROJ' # required
```

When an error occurs (for example HTTP Error) it will inform you but NOT fail whole deployment.

## Checking setup

To check if setup is proper or diagnose a problem run for your environment
```
cap staging jira:check
```

Proper output will be similar to this:
```
=> Required params
jira_username = wojtek@codegarden.online
jira_password = **********
jira_site = https://example.atlassian.net
jira_project_key = PROJ
<= OK
=> Checking connection
<= OK
=> Checking for given project key
<= OK
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-jira.
