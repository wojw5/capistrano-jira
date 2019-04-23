module Capistrano
  module Jira
    class IssueUpdater
      attr_reader :issue

      def initialize(issue)
        @issue = issue
      end

      def comment(args)
        body = "Deployed to [#{fetch(:application_stage)}|https://#{fetch(:fqdn)}].\n"
        body += "{quote}\n#{args[:description]}\n{quote}"
        issue.comments.build.save!(body: body)
      end
    end
  end
end
