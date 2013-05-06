module TestBed
  class Configuration
    attr_reader :repository

    def initialize(args=nil)
      @repository = Grit::Repo.new(git_root)
    end

    def api_token
      repository.config['pivotal.api-token']
    end

    def project_id
      repository.config['pivotal.project-id']
    end

    def use_ssl?
      repository.config['pivotal.use-ssl'] =~ /(1|true)/
    end

    def full_name
      repository.config['pivotal.full-name'] || repository.config['user.name']
    end

    def valid?
      api_token && project_id
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
