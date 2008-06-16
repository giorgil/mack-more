require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  
  describe "error_messages_for" do
    
    before(:all) do
      write_database_yml
      Mack::Database.establish_connection
      class User < ActiveRecord::Base
        validates_presence_of :username
      end
      class Person < ActiveRecord::Base
        validates_presence_of :full_name
      end
      class CreateOrmHelpersModels < ActiveRecord::Migration
        def self.up
          create_table :users do |t|
            t.column :username, :string
          end
          create_table :people do |t|
            t.column :full_name, :string
          end
        end
        def self.down
          drop_table :users
          drop_table :people
        end
      end
      CreateOrmHelpersModels.up
      
      @user = User.new
      @user.save.should == false
      
    end

    after(:all) do
      CreateOrmHelpersModels.down
    end
    
    it "should default to the inline ERB template" do
      error_messages_for(:user).should == %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2>1 error occured.</h2>
    <ul>
      
        <li>User username can't be blank</li>
      
    </ul>
  </div>
</div>
      }
    end
    
    it "should handle multiple models" do
      @person = Person.new
      @person.save.should == false
      error_messages_for([:user, :person]).should == %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2>2 errors occured.</h2>
    <ul>
      
        <li>User username can't be blank</li>
      
        <li>Person full name can't be blank</li>
      
    </ul>
  </div>
</div>
      }
    end
    
    it "should allow you to pass in a partial" do
      pending
    end
    
    it "should find and use the default partial"
    
  end
  
end