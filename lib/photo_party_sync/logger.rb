require 'logger'

module PhotoPartySync
  module Logging
    def logger
      Logging.logger
    end

    def self.logger
      @logger ||= ::Logger.new(STDOUT)
    end
  end
end