require 'helper'

class TestCsvParser < Test::Unit::TestCase
  def parse(string)
    parser = CsvParser::CsvParser.new
    [parser.parse(string), parser.failure_reason]
  end

  test "one record with two fields" do
    result, error = parse("foo,bar")
    assert result, error
    assert_equal [['foo', 'bar']], result.value
  end

  test "one record with one field" do
    result, error = parse("foo")
    assert result, error
    assert_equal [['foo']], result.value
  end

  test "empty records" do
    result, error = parse("")
    assert result, error
    assert_equal [], result.value
  end

  test "empty record" do
    result, error = parse("foo\n\nbar")
    assert result, error
    assert_equal [['foo'], [], ['bar']], result.value
  end

  test "two records" do
    result, error = parse("foo,bar\nbaz,qux")
    assert result, error
    assert_equal [['foo', 'bar'], ['baz', 'qux']], result.value
  end

  test "quoted field" do
    result, error = parse(%{"foo,bar"})
    assert result, error
    assert_equal [["foo,bar"]], result.value
  end

  test "single-character custom field separator" do
    parser = CsvParser::CsvParser.new
    parser.field_sep = "\t"
    result = parser.parse("foo\tbar")
    assert result, parser.failure_reason
    assert_equal [['foo', 'bar']], result.value
  end

  test "multi-character custom field separator" do
    parser = CsvParser::CsvParser.new
    parser.field_sep = "foo"
    result = parser.parse("bazfoobar")
    assert result, parser.failure_reason
    assert_equal [['baz', 'bar']], result.value
  end

  test "single-character custom record separator" do
    parser = CsvParser::CsvParser.new
    parser.record_sep = "x"
    result = parser.parse("fooxbar")
    assert result, parser.failure_reason
    assert_equal [['foo'], ['bar']], result.value
  end

  test "multi-character custom record separator" do
    parser = CsvParser::CsvParser.new
    parser.record_sep = "foo"
    result = parser.parse("barfoobaz")
    assert result, parser.failure_reason
    assert_equal [['bar'], ['baz']], result.value
  end
end
