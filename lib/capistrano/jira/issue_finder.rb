module Capistrano
  module Jira
    class IssueFinder
      include Finder

      execute do |args|
        jql = "id IN ('#{args[:ids].join("','")}')"
        Jira.client.Issue.jql(jql, fields: ['status'], max_results: 1_000_000)
      end
    end
  end
end
