require 'pathname'
require 'ruby-debug'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'
require Pathname(__FILE__).dirname.expand_path + 'create_and_drop_task_helper'

describe "rake" do

  describe "db" do
  
    describe "migrate" do
      include Spec::CreateAndDropTask::Helper::MySQL
      
      after(:all) do
        cleanup_db
      end
      
      it "should migrate the database with the migrations in the db/migrations folder" do
        config_db(:mysql) do
          db_exists?("foo_development").should_not == true
          rake_task("db:recreate")
          db_exists?("foo_development").should == true
          table_exists?("zoos").should_not == true
          
          # now write one migration file, and see if we can get the table created
          data = fixture("002_create_zoos")
          mig_file = File.join(migrations_directory, "002_create_zoos.rb")
          
          File.open(mig_file, "w") { |f| f.write(data) }
          rake_task("db:migrate")
          table_exists?("zoos").should == true
          
          FileUtils.rm_rf(mig_file)
        end
      end
    
    end
  
    describe "rollback" do
      include Spec::CreateAndDropTask::Helper::MySQL
      
      after(:each) do
        cleanup_db
      end
      
      it "should rollback the database by a default of 1 step" do
        config_db(:mysql) do
          db_exists?("foo_development").should_not == true
          rake_task("db:recreate")
          db_exists?("foo_development").should == true
          table_exists?("zoos").should_not == true
          table_exists?("animals").should_not == true
        
          mig_file1 = File.join(migrations_directory, "002_create_zoos.rb")
          mig_file2 = File.join(migrations_directory, "003_create_animals.rb")
        
          # now write one migration file, and see if we can get the table created
          data = fixture("002_create_zoos")
          File.open(mig_file1, "w") { |f| f.write(data) }
          rake_task("db:migrate")
          table_exists?("zoos").should == true
        
          # now write the second migration file, and see if we can see that table
          data = fixture("003_create_animals")
          File.open(mig_file2, "w") { |f| f.write(data) }
          rake_task("db:migrate")
          table_exists?("animals").should == true
        
          # now rollback 1 step, and we shouldn't see "animals" table anymore
          rake_task("db:rollback")
          table_exists?("animals").should_not == true

          FileUtils.rm_rf(mig_file1)
          FileUtils.rm_rf(mig_file2)
        end
      end
    
      it "should rollback the database by n steps if ENV['STEP'] is set" do
        config_db(:mysql) do
          db_exists?("foo_development").should_not == true
          rake_task("db:recreate")
          db_exists?("foo_development").should == true
          table_exists?("zoos").should_not == true
          table_exists?("animals").should_not == true
          
          mig_file1 = File.join(migrations_directory, "002_create_zoos.rb")
          mig_file2 = File.join(migrations_directory, "003_create_animals.rb")
                    
          # now write 2 migration files, and we should see the 2 new tables
          data = fixture("002_create_zoos")
          File.open(mig_file1, "w") { |f| f.write(data) }
          
          data = fixture("003_create_animals")
          File.open(mig_file2, "w") { |f| f.write(data) }
          
          rake_task("db:migrate")
          table_exists?("zoos").should == true
          table_exists?("animals").should == true

          # now set ENV['STEP'] to 2, and we should see those 2 tables go away
          ENV['STEP'] = "2"
          rake_task("db:rollback")
          table_exists?("animals").should_not == true
          table_exists?("zoos").should_not == true

          FileUtils.rm_rf(mig_file1)
          FileUtils.rm_rf(mig_file2)
        end
      end
    
    end
  
    describe "version" do
      include Spec::CreateAndDropTask::Helper::MySQL
            
      after(:all) do
        cleanup_db
      end
    
      it "should return the current version number of the database" do
        config_db(:mysql) do
          db_exists?("foo_development").should_not == true
          rake_task("db:recreate")
          db_exists?("foo_development").should == true
          
          rake_task("db:migrate")
          Mack::Database::Migrator.version.to_s.should_not == ""
        end
      end
    
    end
  
  end
  
end