# Generates scaffold for Mack applications.
# 
# Example:
#   rake generate:scaffold name=post
class ScaffoldGenerator < Genosaurus
  
  require_param :name
  
  def setup # :nodoc:
    @name_singular = param(:name).singular.underscore
    @name_plural = @name_singular.plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase
    @test_framework = configatron.mack.testing_framework
  end
  
  def after_generate # :nodoc:
    ModelGenerator.run(@options)
    ControllerHelperGenerator.run(@options)
    update_routes_file
  end
  
  def showable_columns
    cols = columns.reject {|c| c.column_name.downcase.match(/password/)}
    cols
  end
  
  def update_routes_file # :nodoc:
    # update routes.rb
    routes = Mack::Paths.config("routes.rb")
    rf = File.open(routes).read
    unless rf.match(".resource :#{@name_plural}")
      puts "Updating routes.rb"
      nrf = ""
      rf.each do |line|
        if line.match("Mack::Routes.build")
          x = line.match(/\|(.+)\|/).captures
          line << "\n  #{x}.resource :#{@name_plural} # Added by rake generate:scaffold name=#{param(:name)}\n"
        end
        nrf << line
      end
      File.open(routes, "w") do |f|
        f.puts nrf
      end
    end
  end
  
end