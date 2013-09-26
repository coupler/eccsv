require 'treetop'

require 'csv_parser/version'
require 'csv_parser/parser_extensions'

#Treetop.load(File.join(File.dirname(__FILE__), 'csv_parser.treetop'))
require 'csv_parser/csv_parser'

module CsvParser
  class Error < Exception
    attr_reader :line, :column

    def initialize(msg, line, column)
      super(msg)
      @line = line
      @column = column
    end
  end

  class MissingQuoteError < Error; end
  class StrayQuoteError < Error; end
  class MissingFieldsError < Error; end
  class ExtraFieldsError < Error; end

  def self.parse(data, options = {})
    parser = ::CsvParser::CsvParser.new
    options.each_pair do |key, value|
      parser.send("#{key}=", value)
    end
    result = parser.parse(data)
    if result
      result.value
    else
      klass =
        case parser.failure_description
        when :missing_quote
          MissingQuoteError
        when :stray_quote
          StrayQuoteError
        when :missing_fields
          MissingFieldsError
        when :extra_fields
          ExtraFieldsError
        else
          Error
        end

      raise klass.new(parser.failure_reason, parser.failure_line,
                      parser.failure_column)
    end
  end
end
