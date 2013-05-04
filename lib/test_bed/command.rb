require 'test_bed/command/base'
require 'test_bed/command/list'
require 'test_bed/command/help'

module TestBed
  module Command
    class << self
      def run(args)
        command_for(args.first).call(args)
      rescue CommandError => e
        $stderr.puts e.message
        exit 1
      end

      def commands
        { 'help' => Command::Help,
          'ls'   => Command::List }
      end

      def command_for(name)
        commands[name] || Command::Help
      end
    end
  end
end
