module PtGitHelpers
  def clear_connections
    PivotalTracker::Client.clear_connections
  end

  def api_url
    PivotalTracker::Client.api_ssl_url
  end

  def fixtures_path
    File.join(File.dirname(__FILE__), '../fixtures')
  end

  def read_fixture(filename)
    File.read(File.join(fixtures_path, filename))
  end

  def stub_api(url, fixture_filename, method = :get)
    response = read_fixture(fixture_filename)
    stub_request(method, url).to_return(body: response)
  end

  def stub_stdin_stdout(&block)
    @stdin  ||= StringIO.new
    @stdout ||= StringIO.new
    yield if block_given?
    @output = @stdout.string
  end
end

World(PtGitHelpers)
