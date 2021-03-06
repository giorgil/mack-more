# This will generate an ORM 'model' for your application based on the specified ORM you're using. 
# 
# Example without columns:
#   rake generate:model name=user
# 
# app/models/user.rb:
#   class User < ActiveRecord::Base
#   end
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < ActiveRecord::Migration
#     self.up
#     end
# 
#     self.down
#     end
#   end
# 
# Example with columns:
#   rake generate:model name=user cols=username:string,email_address:string,created_at:datetime,updated_at:datetime
# 
# app/models/user.rb:
#   class User < ActiveRecord::Base
#   end
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < ActiveRecord::Migration
#     self.up
#       create_table :users do |t|
#         t.column :username, :string
#         t.column :email_address, :string
#         t.column :created_at, :datetime
#         t.column :updated_at, :datetime
#     end
# 
#     self.down
#       drop_table :users
#     end
#   end
class ModelGenerator < Genosaurus
  
  require_param :name
  
  def setup # :nodoc:
    @name_singular = param(:name).singular.underscore
    @name_plural = @name_singular.plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase
  end

  def after_generate # :nodoc:
    MigrationGenerator.run(@options.merge({"name" => "create_#{@name_plural}"}))
  end
  
  def testing_framework # :nodoc:
    configatron.mack.testing_framework.to_s
  end
  
end