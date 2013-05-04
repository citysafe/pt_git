require 'aruba/cucumber'
require 'aruba/in_process'
require 'test_bed'
require 'webmock/cucumber'

class TestBedWrapper
  def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    TestBed::Command.run(@argv.dup)
    @kernel.exit(0)
  end
end

Aruba::InProcess.main_class = TestBedWrapper
Aruba.process = Aruba::InProcess
