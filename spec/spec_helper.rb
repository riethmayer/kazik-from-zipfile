# spec_helper.rb ;; 2010 (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
require File.expand_path(File.dirname(__FILE__) + "/../kazik.rb")

lib_folder = File.expand_path(File.dirname(__FILE__) + "/../lib/")
Dir["#{lib_folder}/*.rb"].each do |file|
  require file
end
require 'fileutils'
TEST_DIRECTORY = File.join(FileUtils.pwd,"test")
TEST_FILE = "#{TEST_DIRECTORY}/test.zip"

module TestHelper
  def cleanup
    FileUtils.rm_rf(Dir.glob('test/tmp/*.xml'))
    yield if block_given?
  end
end
