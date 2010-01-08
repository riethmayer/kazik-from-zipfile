# kazik.rb ;; 2010 (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
class Kazik
  attr_accessor :file, :target_directory, :timestamp, :handler, :converted

  def initialize(file_name)
    raise FileMissingException unless File.exists?(file_name)
    raise InvalidFileTypeException unless file_name =~ /\.zip$/
    @file= file_name
    @converted = []
  end

  def process
    extract
    convert
    deliver
    report
  end

  def extract
    @target_directory ||= tmp_with_timestamp_directory
    @handler = Unzip.new(@file, @target_directory)
  end

  def convert
    raise EmptyHandlerException unless @handler.class == Unzip
    @handler.files.each do |file|
      @converted << Converter.convert(file)
    end
  end

  def deliver
    failed = true
    while failed do
      success = Deliver.new(@converted)
      failed = false if success?
    end
    cleanup
  end

  def cleanup
    FileUtils.rm_rf(Dir.glob("#{@target_directory}}/*.xml"))
    FileUtils.rm_rf(@target_directory) if with_timestamp?
  end

  def with_timestamp?
    !!@timestamp
  end

  private
  def tmp_directory
    Dir.mkdir('tmp') unless File.exists?('tmp')
    "tmp"
  end

  def tmp_with_timestamp_directory
    @timestamp = "#{Time.now.strftime("%Y%m%d%H%M%S")}#{rand(1000)}"
    @target_directory = "#{tmp_directory}/#{@timestamp}"
    Dir.mkdir(@target_directory) unless File.exists?(@target_directory)
    @target_directory
  end
end
