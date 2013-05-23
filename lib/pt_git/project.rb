module PtGit
  class Project < PivotalTracker::Project
    include HappyMapper

    def self.current
      init_connection
      find(config.project_id)
    end

    def self.init_connection
      PivotalTracker::Client.token   = config.api_token
      PivotalTracker::Client.use_ssl = config.use_ssl?
    end

    def self.config
      GitConfig.new
    end

    def next_unstarted_stories
      current_backlog.map(&:stories).flatten.select(&:unstarted?)
    end

    def owner_initials_for(story)
      membership = find_membership_by_name(story.owned_by)
      membership.initials if membership
    end

    private

    def find_membership_by_name(name)
      memberships.all.find { |membership| membership.name == name }
    end

    def current_backlog
      PivotalTracker::Iteration.current_backlog(self, limit: 1)
    end
  end
end
