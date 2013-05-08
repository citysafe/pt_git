module TestBed
  class Pivotal

    def list_backlog
      project.next_ten_stories.each_with_index do |story, index|
        puts "#{index}) #{story.story_type} #{story.id} #{story.name}"
      end
    end

    def project
      Project.current
    end

  end
end
