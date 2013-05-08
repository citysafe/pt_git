$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test_bed'
require 'rspec'
require 'factory_girl'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  config.include FactoryGirl::Syntax::Methods
end

def stub_git_config(opts = {})
  git_options = {
    'pivotal.api-token' => '8a8a8a8',
    'pivotal.project-id' => '123',
    'pivotal.use-ssl' => '1',
    'pivotal.full-name' => 'Tien Le',
  }.merge opts

  Grit::Repo.stub(:new).and_return mock('Grit::Repo', config: git_options)
end

# Capture stream output like STDOUT or STDERR
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end
