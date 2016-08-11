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
    puts 'Looking for issues'
    issues = Capistrano::Jira::IssueFinder.new.find
    issues.each do |issue|
      begin
        Capistrano::Jira::IssueTransiter.new(issue).transit
        puts "#{issue.key}\t\u{2713} Transited"
      rescue Capistrano::Jira::TransitionError => e
        puts "#{issue.key}\t\u{2717} #{e.message}"
      end
    end
  end

  desc 'Check JIRA setup'
  task :check do
    errored = false
    required_params = %i(jira_username jira_password jira_site jira_project_key
                         jira_status_name jira_transition_name)
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
