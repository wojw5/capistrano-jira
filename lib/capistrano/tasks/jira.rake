namespace :load do
  task :defaults do
    set :jira_username,                 ENV['CAPISTRANO_JIRA_USERNAME']
    set :jira_password,                 ENV['CAPISTRANO_JIRA_PASSWORD']
    set :jira_site,                     ENV['CAPISTRANO_JIRA_SITE']
    set :jira_project_key,              nil
  end
end

namespace :jira do
  desc 'Update JIRA issues upon deployment'
  task :update_issues do |_t|
    on :app do |_|
      sha_range = "#{fetch(:previous_revision)}...#{fetch(:current_revision)}"
      commits = Capistrano::Jira::CommitFinder.new.find(sha_range: sha_range)

      ids = commits.flat_map { |c| c.ids }.uniq
      info Rainbow("Found #{ids.count} issues across #{commits.count} commit messages").yellow
      begin
        issues = Capistrano::Jira::IssueFinder.new.find(ids: ids)

        issues.each do |issue|
          issue_commits = commits.select { |c| c.ids.include? issue.key }

          commit_description = issue_commits.map { |c| "[#{c.hash}|https://github.com/#{fetch(:github_repos)}/commit/#{c.hash}] - #{c.title}" }.join("\n")

          Capistrano::Jira::IssueUpdater.new(issue).comment(description: commit_description)
          info Rainbow("#{issue.key}").green
          issue_commits.each { |c| info " => #{c.to_s}" }
        end
      rescue JIRA::HTTPError => e
        error "#{e.class} #{e.message}"
      end
    end
  end

  desc 'Check JIRA setup'
  task :check do
    errored = false
    required_params =
      %i[jira_username jira_password jira_site jira_project_key]

    puts '=> Required params'
    required_params.each do |param|
      print "#{param} = "
      if fetch(param).nil? || fetch(param) == ''
        puts '!!!!!! EMPTY !!!!!!'
        errored = true
      else
        puts param == :jira_password ? '**********' : fetch(param)
      end
    end
    raise StandardError, 'Not all required parameters are set' if errored
    puts '<= OK'

    puts '=> Checking connection'
    projects = ::Capistrano::Jira.client.Project.all
    puts '<= OK'

    puts '=> Checking for given project key'
    exist = projects.any? { |project| project.key == fetch(:jira_project_key) }
    unless exist
      raise StandardError, "Project #{fetch(:jira_project_key)} not found"
    end
    puts '<= OK'
  end

  after 'deploy:finished', 'jira:update_issues'
end
