module PtGit
  class Pivotal
    attr_reader :stdin, :stdout

    def initialize(stdin = $stdin, stdout = $stdout)
      @stdin, @stdout = stdin, stdout

      Project.config.install_git_hooks
    end

    def list_backlog
      stories = project.next_unstarted_stories
      stories.each_with_index do |story, index|
        say "#{index + 1}) [#{story.story_type}] [#{story.id}] [#{project.owner_initials_for(story)}] #{story.name}"
      end

      index = ask('Pick a story: ').to_i - 1
      story = stories[index]

      checkout_branch(story)
    end

    def project
      @project ||= Project.current
    end

    private

    def say(str)
      @stdout.puts str
    end

    def ask(prompt)
      say prompt
      @stdin.gets
    end

    def checkout_branch(story)
      return unless story

      branch_name = [story.story_type, story.id].join('-')
      Project.config.repository.git.checkout({B: true, raise: true}, branch_name)
    end

  end
end
