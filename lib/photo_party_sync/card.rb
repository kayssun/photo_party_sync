require 'photo_party_sync/logger'
require 'nokogiri'
require 'open-uri'
require 'photo_party_sync/cardfile.rb'

module PhotoPartySync
  # Represents a remote sd card - sets up connects and gets file list
  class Card
    attr_accessor :target_base_path
    attr_reader :name

    include PhotoPartySync::Logging

    def initialize(name)
      @name = name
    end

    def ready?
      system("ping -c 1 -t 1 '#{@name}' > /dev/null 2>&1")
    end

    def folders
      @folders ||= read_folders
    end

    def read_folders
      folder_list = entry_list('/DCIM')
      folder_list.collect { |row| row.split(',')[1] }
    end

    def files
      found_files = []

      folders.each do |folder|
        file_list = entry_list("/DCIM/#{folder}")
        file_list.each do |file_row|
          file_info = file_row.split ','
          file = CardFile.new
          file.path = file_info[0]
          file.name = file_info[1]
          file.size = file_info[2]
          file.attributes = file_info[3]
          file.date = file_info[4].to_i
          file.time = file_info[5].to_i
          file.target_base_path = @target_base_path if @target_base_path
          file.card = @name
          found_files << file
        end
      end

      found_files
    end

    def download_all
      files.each do |file|
        if file.valid? && !file.exist?
          logger.info "Downloading #{file.name}..."
          file.download
        else
          logger.info "Skipping file #{file.name}..."
        end
      end
    end

    def valid?
      open("http://#{@options[:card]}/command.cgi?op=100&DIR=/DCIM")
      true
    rescue SocketError
      false
    end

    protected

    def entry_list(folder)
      doc = Nokogiri::HTML(open("http://#{@name}/command.cgi?op=100&DIR=#{folder}", read_timeout: 2))
      entries = doc.css('p').first.content.split("\n")
      entries.shift
      entries
    rescue StandardError => e
      logger.warn e.message
      []
    end
  end
end
