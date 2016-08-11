namespace :load do
  task :defaults do
    set :jira_username,        ENV['CAPISTRANO_JIRA_USERNAME']
    set :jira_password,        ENV['CAPISTRANO_JIRA_PASSWORD']
    set :jira_site,            ENV['CAPISTRANO_JIRA_SITE']
    set :jira_project_key,     nil
    set :jira_status_name,     nil
    set :jira_transition_name, nil
    set :jira_filter_jql,      nil
  end
end

namespace :jira do
  desc 'Find and transit possible JIRA issues'
  task :find_and_transit do |_t|
    info 'Looking for issues'
    issues = Capistrano::Jira::IssueFinder.new.find
    issues.each do |issue|
      begin
        Capistrano::Jira::IssueTransiter.new(issue).transmit
        info "#{issue.key}\t\u{2713} Transited"
      rescue Capistrano::Jira::TransitionError => e
        info "#{issue.key}\t\u{2717} #{e.message}"
      end
    end
  end

  after 'deploy:finished', 'jira:find_and_transit'
end
