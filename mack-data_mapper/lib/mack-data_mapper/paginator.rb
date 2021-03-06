module Mack
  module Database
    
    class Paginator
      
      # Implements the paginate method from the Mack::Database::Paginator spec in mack-orm.
      def paginate
        order_clause = [self.query_options.delete(:order)].flatten.compact
          
        self.total_results = self.klass.count(self.query_options)
        self.total_pages = (self.total_results.to_f / self.results_per_page).ceil
        
        self.current_page = self.total_pages if self.current_page > self.total_pages
        
        if order_clause.empty?
          self.klass.key.each do |k| 
            order_clause << k.name.to_sym.asc
          end
        end

        self.query_options.reverse_merge!({
          :order => order_clause
        })
        
        offset = (self.current_page - 1) * self.results_per_page
        offset = 0 if offset < 0
        
        self.query_options.merge!({
          :limit => self.results_per_page, 
          :offset => offset
        })
        
        self.results = self.klass.all(self.query_options)
        self
      end # paginate
      
    end # Paginator
  end # Database
end # Mack

module DataMapper # :nodoc:
  module Resource # :nodoc:
    module ClassMethods # :nodoc:
      
      def paginate(options = {}, query_options = {})
        paginator = Mack::Database::Paginator.new(self, options, query_options)
        paginator.paginate
      end
      
    end # ClassMethods
  end # Resource
end # DataMapper