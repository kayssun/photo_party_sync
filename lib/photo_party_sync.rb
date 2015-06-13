require 'photo_party_sync/version'
require 'photo_party_sync/card'

module PhotoPartySync
  class Watcher
    def initialize(options)
      @options = options

      if @options[:cards].empty?
        puts 'You need to supply a card name.'
        exit 1
      end
    end

    def watch
      while true
        check_all
        sleep 1
      end
    end

    def check_all
      @options[:cards].each do |cardname|
        check_card cardname
      end
    end

    def check_card(cardname)
      card = PhotoPartySync::Card.new(cardname)

      if card.ready?

        puts "Found #{cardname}, getting file list..." unless @options[:quiet]

        card.files.each do |file|
          file.target_base_dir = @options[:dir] unless @options[:dir].empty?
          if file.valid? and not file.exists?
            puts "Downloading #{file.name}..." unless @options[:quiet]
            file.download
          else
            puts "Skipping file #{file.name}..."
          end
        end
      else
        puts "Cannot reach #{cardname}. Skipping." unless @options[:quiet]
      end
    end
  end
end
