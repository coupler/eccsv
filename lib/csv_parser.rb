require 'treetop'
require 'csv_parser/version'

module CsvParser
end

Treetop.load(File.join(File.dirname(__FILE__), 'csv_parser.treetop'))
