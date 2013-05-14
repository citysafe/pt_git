module TestBed
  class Pivotal
    attr_reader :stdin, :stdout

    def initialize(stdin = $stdin, stdout = $stdout)
      @stdin, @stdout = stdin, stdout
    end

    def list_backlog
      project.next_ten_stories.each_with_index do |story, index|
        say "#{index}) #{story.story_type} #{story.id} #{story.name}"
      end
    end

    def project
      Project.current
    end

    private

    def say(str)
      @stdout.puts str
    end
  end
end
