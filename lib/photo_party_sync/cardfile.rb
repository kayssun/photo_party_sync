require 'fileutils'

module PhotoPartySync
  # Provides access to a single file on the remote sd card
  class CardFile
    YEAR_MASK   = 0b1111111000000000
    MONTH_MASK  = 0b0000000111100000
    DAY_MASK    = 0b0000000000011111

    HOUR_MASK   = 0b1111100000000000
    MINUTE_MASK = 0b0000011111100000
    SECOND_MASK = 0b0000000000011111

    BASE_PATH   = File.realdirpath('images')

    attr_accessor :path, :name, :size, :attributes, :card, :target_base_path
    attr_reader :date, :time

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

    def date=(bits)
      year = 1980 + ((bits & CardFile::YEAR_MASK) >> 9)
      month = (bits & CardFile::MONTH_MASK) >> 5
      day = (bits & CardFile::DAY_MASK)
      @date = "#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}"
    end

    def time=(bits)
      hour = (bits & CardFile::HOUR_MASK) >> 11
      minute = (bits & CardFile::MINUTE_MASK) >> 5
      second = (bits & CardFile::SECOND_MASK)
      @time = "#{hour.to_s.rjust(2, '0')}-#{minute.to_s.rjust(2, '0')}-#{second.to_s.rjust(2, '0')}"
    end

    def exist?
      File.exist?(local_path)
    end

    def valid?
      File.extname(@name).downcase == '.jpg' && @name.upcase != 'FA000001.JPG'
    end

    def download
      # logger.info "Downloading: http://#{card}#{path}/#{name}"
      create_directories
      continue = File.exist?(temp_path) ? ' --continue' : ''
      timeout = ' --timeout=5 --tries=1 --dns-timeout=1'
      success = system("wget 'http://#{card}#{path}/#{name}' -O '#{temp_path}'#{continue}#{timeout}")
      FileUtils.mv(temp_path, local_path) if success
      success
    end

    def create_directories
      FileUtils.mkdir_p(File.dirname(temp_path)) unless Dir.exist?(File.dirname(temp_path))
      FileUtils.mkdir_p(File.dirname(local_path)) unless Dir.exist?(File.dirname(local_path))
    end
  end
end
