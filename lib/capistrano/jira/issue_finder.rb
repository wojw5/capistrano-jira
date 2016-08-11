module Capistrano
  module Jira
    class IssueFinder
      attr_reader :issues

      def find!
        @issues = execute
      end

      def find
        @issues ||= execute
      end

      private

      def jql
        [
          "project = #{fetch(:jira_project_key)}",
          "status = #{fetch(:jira_status_name)}",
          fetch(:jira_filter_jql)
        ].compact.join(' AND ')
      end

      def execute
        Jira.client.Issue.jql(jql, fields: ['status'], max_results: 1_000_000)
      end
    end
  end
end
