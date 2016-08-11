require 'capistrano/jira/version'
require 'capistrano/jira/errors'
require 'capistrano/jira/issue_finder'
require 'capistrano/jira/issue_transiter'
require 'jira-ruby'

module Capistrano
  module Jira
    def self.client
      ::JIRA::Client.new(username: fetch(:jira_username),
                         password: fetch(:jira_password),
                         site: fetch(:jira_site),
                         context_path: '',
                         auth_type: :basic)
    end
  end
end

load File.expand_path('../tasks/jira.rake', __FILE__)
