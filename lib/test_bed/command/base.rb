module TestBed
  module Command
    class CommandError < StandardError; end

    class Base
      attr_reader :args, :configuration

      def self.call(args)
        new(args).call
      end

      def initialize(args)
        @configuration = Configuration.new(args)
        initialize_pivotal_tracker_client
      end

      def initialize_pivotal_tracker_client
        if !configuration.valid?
          raise CommandError, "Pivotal Tracker API Token and Project ID are required"
        end

        PivotalTracker::Client.token   = configuration.api_token
        PivotalTracker::Client.use_ssl = configuration.use_ssl?
      end
    end
  end
end
