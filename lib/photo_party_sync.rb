require 'photo_party_sync/version'
require 'photo_party_sync/card'
require 'photo_party_sync/logger'

module PhotoPartySync
  # Calls all cards
  class Watcher
    include PhotoPartySync::Logging

    def initialize(options)
      if options[:cards].empty?
        STDERR.puts 'You need to supply a card name.'
        exit 1
      end

      @options = options

      @options[:cards].each { |card| card.target_base_path = @options[:dir] } unless @options[:dir].empty?
    end

    def watch
      loop do
        check_all
        sleep 1
      end
    end

    def check_all
      @options[:cards].each do |cardname|
        check_card cardname
      end
    end

    def check_card(card)
      if card.ready?
        logger.info "Found #{card.name}, getting file list..." unless @options[:quiet]
        card.download_all
      else
        logger.warn "Cannot reach #{card.name}. Skipping." unless @options[:quiet]
      end
    end
  end
end
