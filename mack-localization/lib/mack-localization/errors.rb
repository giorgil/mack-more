module Mack
  module Localization # :nodoc:
    module Errors # :nodoc:
      
      #
      # Raise this error when caller specified unsupported language.
      # Supported language is defined in configuration as an array of language codes.
      #
      class UnsupportedLanguage < StandardError
        def initialize(lang)
          super("Locale: #{lang} is not currently supported.")
        end
      end
      
      #
      # Raise this error when caller specified an unsupported char encoding.
      # This feature is not currently supported yet.
      #
      class UnsupportedEncoding < StandardError
        def initialize(encoding)
          super("Encoding: #{encoding} is not currently supported")
        end
      end

      #
      # Raise this error if the method called is not yet implemented
      #
      class UnsupportedFeature < StandardError
        def initialize(feature)
          super("Feature: #{feature} is currently unsupported")
        end
      end
      
      # 
      # Raise this error when the user is trying to get a string using an invalid key
      #
      class UnknownStringKey < StandardError
        def initialize(key)
          super("Key: #{key} cannot be found in the language files")
        end
      end
      
      #
      # Raise this error when the formatter cannot find the engine for the given language
      #
      class FormatEngineNotFound < StandardError
        def initialize(lang)
          super("Format engine not found for '#{lang}'")
        end
      end
      
      #
      # Raise this error when the user is calling method that doesn't exist (similar to NoMethodError)
      #
      class InvalidMethodName < StandardError
        def initialize(method_name)
          super("Unknown method: #{method_name}")
        end
      end
      
      class InvalidArgument < StandardError
        def initialize(param_name)
          super("Invalid argument passed into method: param_name")
        end
      end
      
      #
      # Raise this error when the configuration file is not properly setup
      #
      class InvalidConfiguration < StandardError
      end
      
      #
      # Raise this error if a language file is missing
      #
      class LanguageFileNotFound < StandardError
        def initialize(lang)
          super("Language file '#{lang}' not found")
        end
      end
    end
  end
end