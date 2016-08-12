module Capistrano
  module Jira
    class TransitionError < StandardError; end
    class FinderError < StandardError; end

    module ErrorHelpers
      def error_message(e)
        case e
        when JIRA::HTTPError
          r = e.response
          "#{r.class.name}; #{r.code}: #{r.message} \n #{r.body}"
        else
          e.message
        end
      end
    end
  end
end
