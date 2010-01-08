# unzip.rb ;; 2010 (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
class Unzip
  attr_reader :files
  def initialize(zipfile, directory)
    if File.exists?(zipfile) && File.exists?(directory)
      @filename= zipfile
      @target_directory= directory
      @files = extract
    else
      raise FileMissingException
    end
  end

  private
  def extract
    files_before_extraction = Dir["#{@target_directory}/*"]
    %x{ unzip -d #{@target_directory} -o #{@filename} }
    files_after_extraction = Dir["#{@target_directory}/*"]

    files_after_extraction - files_before_extraction
  end
end
