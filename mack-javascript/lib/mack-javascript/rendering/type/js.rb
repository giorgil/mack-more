module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render an XML template that's relative to a controller.
      # 
      # Example:
      #   class UsersController < Mack::Controller::Base
      #     # /users/:id
      #     def show
      #       @user = User.first(params(:id))
      #     end
      #     # /users
      #     def index
      #       @users = User.all
      #       render(:xml, :list)
      #     end
      #   end
      # When some calls /users/1.xml the file: app/views/users/show.xml.builder will be rendered.
      # When some calls /users.xml the file: app/views/users/list.xml.builder will be rendered.
      class Js < Mack::Rendering::Type::FileBase
        
        # See Mack::Rendering::Type::FileBase render_file for more information.
        def render
          self.options[:format] = "js"
          self.controller.response["Content-Type"] = Mack::Utils::MimeTypes[self.options[:format]]
          x_file = File.join(self.controller_view_path, "#{self.render_value}.#{self.options[:format]}")
          render_file(x_file, :js)
        end
        
      end # Xml
    end # Type
  end # Rendering
end # Mack