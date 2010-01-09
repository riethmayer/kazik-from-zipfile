# kazik_spec.rb ;; 2010 (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
require "spec_helper"

describe "Kazik converter" do

  include TestHelper

  describe "initialization" do
    it "should raise a ArgumentError if the argument is missing" do
      lambda { Kazik.new }.should raise_error ArgumentError
    end

    it "should raise a file_missing_exception if the file is missing" do
      lambda { Kazik.new("missing") }.should raise_error FileMissingException
    end

    it "should not raise a file_missing_exception a file is provided" do
      lambda { Kazik.new("kazik.rb") }.should_not raise_error FileMissingException
    end

    it "should raise an error if the file is no zipfile" do
      lambda { Kazik.new("kazik.rb") }.should raise_error InvalidFileTypeException
    end

    it "should not raise an invalid_file_type_exception if the file is a zipfile" do
      lambda { Kazik.new("test/test.zip") }.should_not raise_error InvalidFileTypeException
    end

    describe "with valid params" do

      before :each do
        @kazik = Kazik.new TEST_FILE
      end

      it "should have a file attribute" do
        @kazik.file.should == TEST_FILE
      end

      it "should have an empty target_directory" do
        @kazik.target_directory.should be nil
      end

      it "should have no converted items" do
        @kazik.converted.should == []
      end
    end

  end

  describe "extraction" do
    before :each do
      @file = Kazik.new TEST_FILE
    end

    it "should have a target directory after extraction" do
      @file.extract
      @file.target_directory.should match /tmp\/\d{15}/
    end

    it "should unpack the zipfile" do
      @file.target_directory= "#{TEST_DIRECTORY}/tmp"
      unpacked = @file.extract
      unpacked.files.size.should be > 0
    end

    it "should return an unzip object" do
      unpacked = @file.extract
      unpacked.should be_an_instance_of Unzip
    end

    it "should unpack to a timestamped directory if target_directory is unspecified" do
      handler = @file.extract
      @file.with_timestamp?.should == true
    end

    after :each do
      cleanup do
        @file.cleanup
      end
    end
  end

  describe "conversion" do

    before :each do
      @file = Kazik.new TEST_FILE
      @unpacked = @file.extract
    end

    it "should convert all extracted files" do
      @file.convert.size.should == @unpacked.files.size
    end

    after :each do
      cleanup do
        @file.cleanup
      end
    end
  end

  it "should send files via ftp"
  it "should report back to kazik"
end
