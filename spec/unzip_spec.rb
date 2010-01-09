# kazik_spec.rb ;; 2010 (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
require "spec_helper"

describe "Unzip" do

  include TestHelper

  it "should require the file and target directory" do
    lambda { Unzip.new }.should raise_error ArgumentError
    lambda { Unzip.new "bla", "blubb" }.should raise_error FileMissingException
    lambda { Unzip.new TEST_FILE, TEST_DIRECTORY }.should_not raise_error FileMissingException
  end

  it "should call extract on initialize" do
    u = Unzip.new TEST_FILE, "#{TEST_DIRECTORY}/tmp"
    u.files.size.should == 5
  end

  after :each do
    cleanup
  end

end
