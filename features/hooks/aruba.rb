Before do
  @aruba_timeout_seconds = 20

  if ENV['TDDIUM'] then
    path = File.join(ENV['TDDIUM_REPO_ROOT'], 'tmp', "aruba#{ENV['TDDIUM_TID']}")
    FileUtils.mkdir_p(path)
    @dirs = [path]
    FileUtils.rm_rf(current_dir)
  end
end
