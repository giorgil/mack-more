module Mack
  module Database
    
    def self.establish_connection(env = Mack.env)
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      settings = dbs[env]
      settings.symbolize_keys!
      if settings[:default]
        settings.each do |k,v|
          DataMapper.setup(k, v.symbolize_keys)
        end
      else
        DataMapper.setup(:default, settings)
      end
    end # establish_connection
    
    def self.create(env = Mack.env)
      Mack::Database.establish_connection(env)
      drop_create_database
    end
    
    def self.drop(env = Mack.evn)
      Mack::Database.establish_connection(env)
    end
    
    private
    def tmp_mysql_config
      
    end
    
    
    def self.drop_create_database
      uri = repository(:default).adapter.uri
      case repository(:default).adapter.class.name
        when /Mysql/
          DataMapper.setup(:tmp, {
            :adapter => "mysql",
            :host => "localhost",
            :database => "mysql",
            :username => ENV["DB_USERNAME"] || "root",
            :password => ENV["DB_PASSWORD"] || ""
          })
          repository(:tmp) do |repo|
            puts "Dropping (MySQL): #{uri.basename}"
            repo.adapter.execute "DROP DATABASE IF EXISTS `#{uri.basename}`"
            puts "Creating (MySQL): #{uri.basename}"
            repo.adapter.execute "CREATE DATABASE `#{uri.basename}` DEFAULT CHARACTER SET `utf8`"
          end
        when /Postgres/
          DataMapper.setup(:tmp, {
            :adapter => "postgres",
            :host => "localhost",
            :database => "postgres",
            :username => ENV["DB_USERNAME"] || uri.user,
            :password => ENV["DB_PASSWORD"] || uri.password
          })
          repository(:tmp) do |repo|
            puts "Dropping (PostgreSQL): #{uri.basename}"
            repo.adapter.execute "DROP DATABASE IF EXISTS #{uri.basename}"
            puts "Creating (PostgreSQL): #{uri.basename}"
            repo.adapter.execute "CREATE DATABASE #{uri.basename} ENCODING = 'utf8'"
          end
        when /Sqlite3/
          puts "Dropping (SQLite3): #{uri.basename}"
          db_dir = File.join(Mack.root, "db")
          FileUtils.rm_rf(File.join(db_dir.to_s, uri.basename))
          puts "Creating (SQLite3): #{uri.basename}"
          FileUtils.mkdir_p(db_dir)
          FileUtils.touch(File.join(db_dir, uri.basename))
        else
          raise "Task not supported for '#{repository(:default).adapter.class.name}'"
      end
    end
    
  end # Database
  
end # Mack