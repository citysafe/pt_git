module TestBed
  class Configuration
    attr_accessible :repository

    def initialize(*args)
      @repository = Grit::Repo.new(git_root)
    end

    def api_token
      repository.config['pivotal.api-token']
    end

    def project_id
      repository.config['pivotal.project-id']
    end

    private

      def git_dir
        ENV['GIT_DIR'] || '.git'
      end

      def git_root
        directories = Dir.pwd.split(::File::SEPARATOR)

        begin
          break if File.directory?(File.join(directories, git_dir))
        end while directories.pop

        raise "No #{git_dir} directory found" if directories.empty?
        File.join(directories, git_dir)
      end
  end
end
