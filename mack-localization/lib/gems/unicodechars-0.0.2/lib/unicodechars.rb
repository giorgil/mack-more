Dir[File.join(File.dirname(__FILE__), 'unicodechars/**/*.rb')].sort.each { |lib| require lib }