require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ModelGenerator do
  
  before(:each) do
    @model_file = Mack::Paths.models("zoo.rb")
    FileUtils.rm_rf(@model_file)
    FileUtils.rm_rf(Mack::Paths.migrations)
    FileUtils.rm_rf(Mack::Paths.model_tests)
  end
  
  after(:each) do
    FileUtils.rm_rf(@model_file)
    FileUtils.rm_rf(Mack::Paths.migrations)
    FileUtils.rm_rf(Mack::Paths.model_tests)
  end
  
  it "should require a name for the model" do
    lambda{ModelGenerator.new}.should raise_error(ArgumentError)
    ModelGenerator.new("NAME" => "zoo").should be_instance_of(ModelGenerator)
  end
  
  it "should create an empty file for the model" do
    File.should_not be_exists(@model_file)
    ModelGenerator.run("NAME" => "zoo")
    File.should be_exists(@model_file)
    File.read(@model_file).should == fixture("zoo_empty.rb")
  end
  
  it "should create a full file for the model" do
    File.should_not be_exists(@model_file)
    ModelGenerator.run(zoo_options)
    File.should be_exists(@model_file)
    File.read(@model_file).should == fixture("zoo.rb")
  end
  
  it "should create a stub test/unit test for the model if test/unit is testing framework" do
    temp_app_config(:mack => {:testing_framework => "test_case"}) do
      File.should_not be_exist(Mack::Paths.model_tests("zoo_test.rb"))
      ModelGenerator.run(zoo_options)
      File.should be_exist(Mack::Paths.model_tests("zoo_test.rb"))
      File.read(Mack::Paths.model_tests("zoo_test.rb")).should == fixture("zoo_test.rb")
    end
  end
  
  it "should create a stub rspec test for the model if rspec is testing framework" do
    temp_app_config(:mack => {:testing_framework => "rspec"}) do
      File.should_not be_exist(Mack::Paths.model_tests("zoo_spec.rb"))
      ModelGenerator.run(zoo_options)
      File.should be_exist(Mack::Paths.model_tests("zoo_spec.rb"))
      File.read(Mack::Paths.model_tests("zoo_spec.rb")).should == fixture("zoo_spec.rb")
    end
  end
  
  it "should create a migration file" do
    mig_file = Mack::Paths.migrations("001_create_zoos.rb")
    File.should_not be_exists(mig_file)
    ModelGenerator.run(zoo_options)
    File.should be_exists(mig_file)
  end
  
  def zoo_options
    {"name" => "zoo", "cols" => "name:string,description:text,password:string,birth_date:date,member_since:date_time,created_at:date_time,updated_at:date_time"}
  end
  
end