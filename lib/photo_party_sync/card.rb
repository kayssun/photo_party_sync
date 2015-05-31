module PhotoPartySync

  #!/usr/bin/ruby
  #encoding: utf-8

  require 'nokogiri'
  require 'open-uri'
  require 'photo_party_sync/cardfile.rb'

  class Card

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
      begin
        doc = Nokogiri::HTML(open("http://#{@name}/command.cgi?op=100&DIR=/DCIM", read_timeout: 2))
      rescue Exception => e
        puts e.message
        return []
      end
      folder_list = doc.css('p').first.content.split("\n")
      folder_list.shift
      folder_list.collect{|row| row.split(',')[1]}
    end

    def files
      found_files = []

      folders.each do |folder|

        doc = Nokogiri::HTML(open("http://#{@name}/command.cgi?op=100&DIR=/DCIM/#{folder}"))
        file_list = doc.css('p').first.content.split("\n")
        file_list.shift
        file_list.each do |file_row|
          #puts file_row
          file_info = file_row.split ','
          file = CardFile.new
          file.path = file_info[0]
          file.name = file_info[1]
          file.size = file_info[2]
          file.attributes = file_info[3]
          file.date = file_info[4].to_i
          file.time = file_info[5].to_i
          file.card = @name
          found_files << file
        end
      end

      found_files
    end

    def valid?
      begin
        open("http://#{@options[:card]}/command.cgi?op=100&DIR=/DCIM")
        true
      rescue SocketError
        false
      end
    end
  end
end