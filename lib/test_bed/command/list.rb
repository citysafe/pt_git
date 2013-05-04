module TestBed
  module Command
    class List < Base
      def call
        stories = fetch_stories
        stories.each_with_index do |s, i|
          $stdout.puts "#{i}) #{s.story_type} #{s.id} #{s.name}"
        end
      end

      private

        def project
          @project ||= PivotalTracker::Project.find(configuration.project_id)
        end

        def fetch_stories(limit=10)
          conditions = {
            current_state: ['unstarted'],
            limit: limit,
            story_type: %w(bug chore feature)
          }

          project.stories.all(conditions)
        end
    end
  end
end
