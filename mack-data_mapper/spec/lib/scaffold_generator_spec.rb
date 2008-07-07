require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ScaffoldGenerator do
  
  before(:each) do
    @model_file = Mack::Paths.models("zoo.rb")
    @controller_file = Mack::Paths.controllers("zoos_controller.rb")
    @old_route_file = File.read(Mack::Paths.config("routes.rb"))
    common_cleanup
  end
  
  after(:each) do
    common_cleanup
  end
  
  it "should require a name for the scaffold"
  
  it "should handle plural/singular names correctly"
  
  it "should update the routes.rb file with the resource name"
  
  it "should create a stub test/unit test for the controller if test/unit is testing framework"
  
  it "should create a stub rspec test for the controller if rspec is testing framework"
  
  it "should create a controller file"
  
  it "should create the proper view files"
  
  it "should create a model file"
  
  it "should create a migration file"
  
  def common_cleanup
    FileUtils.rm_rf(@model_file)
    FileUtils.rm_rf(@controller_file)
    FileUtils.rm_rf(Mack::Paths.migrations)
    FileUtils.rm_rf(Mack::Paths.views("zoos"))
    FileUtils.rm_rf(Mack::Paths.unit)
    FileUtils.rm_rf(Mack::Paths.functional)
    File.open(Mack::Paths.config("routes.rb"), "w") {|f| f.puts @old_route_file}
  end
  
end