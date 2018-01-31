module Capistrano
  module Jira
    class CommitFinder
      include Finder

      execute do
        `git log -n#{fetch(:jira_commit_messages_limit)} --no-merges --pretty=format:"%h %s"`
          .split("\n").map { |log| Commit.new(log) }
      end
    end
  end
end
