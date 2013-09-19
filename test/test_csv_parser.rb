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
end
