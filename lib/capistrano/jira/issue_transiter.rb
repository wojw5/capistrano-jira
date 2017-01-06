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
        return if transition
        raise TransitionError,
              "Transition #{fetch(:jira_transition_name)} not available"
      end

      def execute
        issue.transitions.build.save!(transition_hash)
      rescue JIRA::HTTPError => e
        raise TransitionError, error_message(e)
      end

      def transition_hash
        hash = { transition: { id: transition.id } }
        hash.merge(comment_hash) if fetch(:jira_comment_on_transition)
        hash
      end

      def comment_hash
        { update:
          { comment: [
            { add:
               {
                 body: 'Issue transited automatically during deployment.'
               } }
          ] } }
      end
    end
  end
end
