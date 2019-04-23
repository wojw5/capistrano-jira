module Capistrano
  module Jira
    class Commit
      attr_reader :raw, :title, :message, :hash, :ids

      def initialize(log)
        @raw = log
        @hash= log[0...9]&.gsub "\n", ""

        @ids = log.upcase.enum_for(:scan, /(?=#{fetch(:jira_project_key)}-)/).map { Regexp.last_match.offset(0).first }.map { |index| log[index, 11].upcase }

        array = log[10..-1]&.split("\n", 2)
        @title = array.try("[]", 0)
        @message = array.try("[]", 1)&.gsub "\n", " "
      end

      def to_s
        "#{hash} - #{title}"
      end
    end
  end
end
