namespace :load do
  task :defaults do
    set :jira_username,                 ENV['CAPISTRANO_JIRA_USERNAME']
    set :jira_password,                 ENV['CAPISTRANO_JIRA_PASSWORD']
    set :jira_site,                     ENV['CAPISTRANO_JIRA_SITE']
    set :jira_project_key,              nil
    set :jira_status_name,              nil
    set :jira_transition_name,          nil
    set :jira_filter_jql,               nil
    set :jira_comment_on_transition,    true
    set :jira_validate_commit_messages, false
    set :jira_commit_messages_limit,    1000
  end
end

namespace :jira do
  desc 'Find and transit possible JIRA issues'
  task :find_and_transit do |_t|
    on :all do |_host|
      if fetch(:jira_validate_commit_messages)
        info 'Finding commit messages'
        commits = Capistrano::Jira::CommitFinder.new.find
      end

      info 'Looking for issues'
      begin
        issues = Capistrano::Jira::IssueFinder.new.find

        issues.each do |issue|
          begin
            if fetch(:jira_validate_commit_messages)
              commit = commits.find { |c| c.message.include?(issue.key)}
              if commit
                Capistrano::Jira::IssueTransiter.new(issue).transit
                info "#{issue.key}\t\u{2713} Transited\tCommit: #{commit.hash}"
              else
                info "#{issue.key}\t\u{21B7} Skipped"
              end
            else
              Capistrano::Jira::IssueTransiter.new(issue).transit
              info "#{issue.key}\t\u{2713} Transited"
            end
          rescue Capistrano::Jira::TransitionError => e
            warn "#{issue.key}\t\u{2717} #{e.message}"
          end
        end
      rescue Capistrano::Jira::FinderError => e
        error "#{e.class} #{e.message}"
      end
    end
  end

  desc 'Check JIRA setup'
  task :check do
    errored = false
    required_params =
      %i[jira_username jira_password jira_site jira_project_key
         jira_status_name jira_transition_name jira_comment_on_transition]

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

  after 'deploy:finished', 'jira:find_and_transit'
end
