#
# AR db create/drop.
# Currently it supports 3 adapters: sqlite3, postgresql, and mysql
#
# ds - July 2008
#

module Mack
  module Database
    
    module Migrator
      def self.version
        ActiveRecord::Migrator.current_version
      end
      
      def self.migrate
        ActiveRecord::Migrator.up(File.join(Mack.root, "db", "migrations"))
      end
      
      def self.rollback(step = 1)
        step = (ENV["STEP"] || step).to_i
        cur_version = version.to_i
        target_version = cur_version - step 
        target_version = 0 if target_version < 0
        
        ActiveRecord::Migrator.down(File.join(Mack.root, "db", "migrations"), target_version)
      end
      
    end
        
    def self.db_settings(env)
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      dbs = dbs[env]
      dbs.symbolize_keys!
      return dbs
    end
    
    def self.establish_connection(env)
      dbs = db_settings(env)
      ActiveRecord::Base.establish_connection(dbs)
    end
    
    # Perform db create or drop
    # 
    # By default the mode is drop then create, but caller will be able to 
    # call this routine with a specific action (:drop, :create, or :drop_and_create)
    # 
    def self.drop_or_create_database(env, mode = :drop_and_create)
      dbs = db_settings(env)
      case dbs[:adapter]
        when "mysql"
          establish_mysql_connection
          drop_mysql_db(env, dbs) if mode == :drop or mode == :drop_and_create
          create_mysql_db(env, dbs) if mode == :create or mode == :drop_and_create
          
        when "postgresql"
          ENV['PGHOST']     = dbs[:host] if dbs[:host]
          ENV['PGPORT']     = dbs[:port].to_s if dbs[:port]
          ENV['PGPASSWORD'] = dbs[:password].to_s if dbs[:password]
          
          ActiveRecord::Base.clear_active_connections!
          drop_postgresql_db(env, dbs) if mode == :drop or mode == :drop_and_create
          create_postgresql_db(env, dbs) if mode == :create or mode == :drop_and_create
          
        when "sqlite3"
          ActiveRecord::Base.clear_active_connections!
          FileUtils.rm_rf(dbs[:database]) if mode == :drop or mode == :drop_and_create
      end
    end
            
    private
    
    def self.drop_postgresql_db(env, dbs)
      begin
        puts "Dropping (PostgreSQL): #{dbs[:database]}"
        `dropdb -U "#{dbs[:username]}" #{dbs[:database]}`
      rescue Exception => e
        puts e
      end
    end
    
    def self.create_postgresql_db(env, dbs)
      begin
        enc_option = "-E #{dbs[:encoding]}" if dbs[:encoding]
        puts "Creating (PostgreSQL): #{dbs[:database]}"
        `createdb #{enc_option} -U "#{dbs[:username]}" #{dbs[:database]}`
      rescue Exception => e
        puts e
      end
    end
    
    def self.establish_mysql_connection
      # connect to mysql meta database
      ActiveRecord::Base.establish_connection(
        :adapter => "mysql",
        :host => "localhost",
        :database => "mysql",
        :username => ENV["DB_USERNAME"] || "root",
        :password => ENV["DB_PASSWORD"] || ""
      )
    end
    
    def self.create_mysql_db(env, dbs)
      if dbs[:collation]
        puts "Dropping (MySQL): #{dbs[:database]}"
        ActiveRecord::Base.connection.execute "CREATE DATABASE `#{dbs[:database]}` DEFAULT CHARACTER SET `#{dbs[:charset] || 'utf8'}` COLLATE `#{dbs[:collation]}`"
      else
        puts "Creating (MySQL): #{dbs[:database]}"
        ActiveRecord::Base.connection.execute "CREATE DATABASE `#{dbs[:database]}` DEFAULT CHARACTER SET `#{dbs[:charset] || 'utf8'}`"
      end
    end
    
    def self.drop_mysql_db(env, dbs)
      puts "Dropping (MySQL): #{dbs[:database]}"
      ActiveRecord::Base.connection.execute "DROP DATABASE IF EXISTS `#{dbs[:database]}`"
    end
  end
end