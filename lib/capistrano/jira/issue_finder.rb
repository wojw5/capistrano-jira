module Capistrano
  module Jira
    class IssueFinder
      include Finder
      include ErrorHelpers

      execute do
        begin
          Jira.client.Issue.jql(jql, fields: ['status'], max_results: 1_000_000)
        rescue JIRA::HTTPError => e
          raise FinderError, error_message(e)
        end
      end

      private

      def self.jql
        [
          "project = #{fetch(:jira_project_key)}",
          "status = #{fetch(:jira_status_name)}",
          fetch(:jira_filter_jql)
        ].compact.join(' AND ')
      end
    end
  end
end
