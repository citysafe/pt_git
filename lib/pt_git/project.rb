module PtGit
  class Project < PivotalTracker::Project
    include HappyMapper

    MAX_ITERATIONS = 20

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

    def next_unstarted_stories(story_limit = 10, iteration_offset = 0, iteration_limit = 2)
      return [] if story_limit.zero? || iteration_offset > MAX_ITERATIONS

      stories = unstarted_stories_of_iterations(iteration_offset, iteration_limit)[0, story_limit]
      stories += next_unstarted_stories(story_limit - stories.size, iteration_offset + iteration_limit + 1)
    end

    def owner_initials_for(story)
      membership = find_membership_by_name(story.owned_by)
      membership.initials if membership
    end

    private

    def find_membership_by_name(name)
      memberships.all.find { |membership| membership.name == name }
    end

    def iterations(offset, limit)
      PivotalTracker::Iteration.current_backlog(self, offset: offset, limit: limit)
    end

    def unstarted_stories_of_iterations(offset, limit)
      iterations(offset, limit).map(&:stories).flatten.select(&:unstarted?)
    end
  end
end
