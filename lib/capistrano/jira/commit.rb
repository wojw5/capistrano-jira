module Capistrano
  module Jira
    class Commit
      attr_reader :message, :hash

      def initialize(log)
        @hash= log[0...8]
        @message = log[9..-1]
      end
    end
  end
end
