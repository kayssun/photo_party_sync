#!/usr/bin/ruby
#encoding: utf-8

require 'fileutils'

module PhotoPartySync
  class CardFile

    YEAR_MASK   = 0b1111111000000000
    MONTH_MASK  = 0b0000000111100000
    DAY_MASK    = 0b0000000000011111

    HOUR_MASK   = 0b1111100000000000
    MINUTE_MASK = 0b0000011111100000
    SECOND_MASK = 0b0000000000011111

    BASE_PATH   = File.realdirpath('images')

    attr_accessor :path, :name, :size, :attributes, :card, :target_base_path

    def initialize
      @path = ''
      @name = ''
      @size = ''
      @attributes = ''
      @card = ''
      @target_base_path = BASE_PATH
    end

    def to_s
      "#{@path}/#{@name} (#{@size} Bytes, #{@date} #{@time})"
    end

    def local_filename
      "#{@date}_#{@time}_#{@card}" + File.extname(@name).downcase
    end

    def temp_path
      "temp/#{@card}/#{local_filename}"
    end

    def local_path
      @target_base_path + "/#{card}/#{local_filename}"
    end

    def date
      @date
    end

    def date=(bits)
      year = 1980 + ((bits & CardFile::YEAR_MASK) >> 9)
      month = (bits & CardFile::MONTH_MASK) >> 5
      day = (bits & CardFile::DAY_MASK)
      @date = "#{year}-#{month < 10 ? '0'+month.to_s : month.to_s}-#{day < 10 ? '0'+day.to_s : day.to_s}"
    end

    def time
      @time
    end

    def time=(bits)
      hour = (bits & CardFile::HOUR_MASK) >> 11
      minute = (bits & CardFile::MINUTE_MASK) >> 5
      second = (bits & CardFile::SECOND_MASK)
      @time = "#{hour < 10 ? '0'+hour.to_s : hour.to_s}-#{minute < 10 ? '0'+minute.to_s : minute.to_s}-#{second < 10 ? '0'+second.to_s : second.to_s}"
    end

    def exists?
      File.exists?(local_path)
    end

    def valid?
      File.extname(@name).downcase == '.jpg' && @name.upcase != 'FA000001.JPG'
    end

    def download
      # logger.info "Downloading: http://#{card}#{path}/#{name}"
      FileUtils.mkdir_p(File.dirname(temp_path)) unless Dir.exists?(File.dirname(temp_path))
      FileUtils.mkdir_p(File.dirname(local_path)) unless Dir.exists?(File.dirname(local_path))
      continue = File.exists?(temp_path) ? ' --continue' : ''
      timeout = ' --timeout=5'
      success = system("wget 'http://#{card}#{path}/#{name}' -O '#{temp_path}'#{continue}#{timeout} --tries=1 --dns-timeout=1")
      if success
        FileUtils.mv(temp_path, local_path)
      end
      success
    end
  end
end