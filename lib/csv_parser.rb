require 'treetop'

require 'csv_parser/version'
require 'csv_parser/parser_extensions'
require 'csv_parser/result'

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
      warnings = parser.warnings.collect do |(desc, line, col)|
        error(desc, line, col)
      end
      Result.new(result.value, warnings)
    else
      raise error(parser.failure_type, parser.failure_line,
                  parser.failure_column, parser.failure_reason)
    end
  end

  def self.error(type, line, column, msg = nil)
    klass, msg =
      case type
      when :missing_quote
        [MissingQuoteError, "no ending quote found for quote on line #{line}, column #{column}"]
      when :stray_quote
        StrayQuoteError
      when :missing_fields
        MissingFieldsError
      when :extra_fields
        ExtraFieldsError
      else
        Error
      end

    klass.new(msg, line, column)
  end
end
