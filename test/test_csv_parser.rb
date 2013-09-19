require 'helper'

class TestCsvParser < Test::Unit::TestCase
  def assert_parseable(string)
    parser = CsvParser::CsvParser.new
    result = parser.parse(string)
    assert result, parser.failure_reason
  end

  test "one record with two fields" do
    assert_parseable "foo,bar"
  end

  test "one record with one field" do
    assert_parseable "foo"
  end

  test "empty record" do
    assert_parseable ""
  end

  test "two records" do
    assert_parseable "foo,bar\nbaz,qux"
  end
end
