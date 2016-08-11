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
        @transition ||= issue.transitions.all.find do |t|
          t.attrs['name'].casecmp(fetch(:jira_transition_name)).zero?
        end
      end

      def validate_transition
        unless transition
          raise TransitionError,
                "Transition #{fetch(:jira_transition_name)} not available"
        end
      end

      def execute
        issue.transitions.build.save!(transition: { id: transition.id })
      rescue JIRA::HTTPError => e
        r = e.response
        raise TransitionError,
              "#{r.class.name}; #{r.code}: #{r.message} \n #{r.body}"
      end
    end
  end
end
