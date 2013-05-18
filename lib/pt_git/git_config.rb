module PtGit
  class GitConfig

    attr_reader :repository

    def initialize
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

    def current_branch
      repository.head.name
    end

    def install_git_hooks
      hook_templates = Dir[File.expand_path('../git_hooks/*', __FILE__)]
      FileUtils.install hook_templates, git_hooks_dir, mode: 0755
    end

    private

    def git_dir
      ENV['DOT_GIT_DIR'] || '.git'
    end

    def git_root
      directories = Dir.pwd.split(::File::SEPARATOR)

      begin
        break if File.directory?(File.join(directories, git_dir))
      end while directories.pop

      raise "No #{git_dir} directory found" if directories.empty?
      File.join(directories, git_dir)
    end

    def git_hooks_dir
      File.join(git_root, 'hooks').tap do |hooks_dir|
        FileUtils.mkdir_p hooks_dir
      end
    end

  end
end
