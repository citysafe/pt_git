module TestBed
  class Configuration
    GIT_DIR = ENV['GIT_DIR'] || '.git'

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

      def git_root
        directories = Dir.pwd.split(::File::SEPARATOR)

        begin
          break if File.directory?(File.join(directories, GIT_DIR))
        end while directories.pop

        raise "No #{GIT_DIR} directory found" if directories.empty?
        File.join(directories, GIT_DIR)
      end
  end
end
