module Capistrano
  module Jira
    class IssueTransiter
      attr_reader :issue

      def initialize(issue)
        @issue = issue
      end

      def transit
        validate_transition
        execute
      end

      private

      def transition
        @transition ||= issue.transitions.find do |t|
          t.attrs['name'].casecmp(fetch(:jira_transition_name)).zero?
        end
      end

      def validate_transition
        raise TransitionError,
              "Transition #{fetch(:jira_transition_name)} not available"
      end

      def execute
        transition.save!
      rescue JIRA::HTTPError => e
        r = e.response
        raise TransitionError, "#{r.class.name}; #{r.code}: #{r.message}"
      end
    end
  end
end
