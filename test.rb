require __dir__ + '/lib/eccsv'
require 'pp'

parser = ECCSV::Parser.new
pp parser.parse(%{foo,bar\nbaz,qux})
