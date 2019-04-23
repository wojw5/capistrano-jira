module Capistrano
  module Jira
    class CommitFinder
      include Finder

      execute do |args|
        splitter = "~~~~~~~"
        `git log #{args[:sha_range]} --no-merges --pretty=format:'%h %B #{splitter}'`.split(splitter).map { |log| Commit.new(log) }
      end
    end
  end
end
