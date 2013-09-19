require 'treetop'
require 'csv_parser/version'
require 'csv_parser/parser_extensions'

module CsvParser
end

Treetop.load(File.join(File.dirname(__FILE__), 'csv_parser.treetop'))
