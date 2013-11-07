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

  test "empty record is skipped by default" do
    result, error = parse("foo\n\nbar")
    assert result, error
    assert_equal [['foo'], ['bar']], result.value
  end

  test "skipping empty record at end" do
    result, error = parse("foo\nbar\n")
    assert result, error
    assert_equal [['foo'], ['bar']], result.value
  end

  test "not skipping an empty record" do
    parser = CsvParser::CsvParser.new
    parser.skip_empty_record = false
    result = parser.parse("foo\n\nbar")
    assert_equal [['foo'], [], ['bar']], result.value
  end

  test "not skipping empty record at end" do
    parser = CsvParser::CsvParser.new
    parser.skip_empty_record = false
    result = parser.parse("foo\nbar\n")
    assert_equal [['foo'], ['bar'], []], result.value
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

  test "missing closing quote" do
    parser = CsvParser::CsvParser.new
    result = parser.parse(%{"foo})
    assert !result
    assert_equal :missing_quote, parser.failure_description
  end

  test "quote inside unquoted field" do
    parser = CsvParser::CsvParser.new
    result = parser.parse(%{f"oo})
    assert !result
    assert_equal :stray_quote, parser.failure_description
  end

  test "missing fields gets warning by default" do
    parser = CsvParser::CsvParser.new
    result = parser.parse(%{foo,bar\nbaz})
    assert result, parser.failure_reason
    assert_equal [[:missing_fields, 2, 4]], parser.warnings
  end

  test "missing fields when disallowed" do
    parser = CsvParser::CsvParser.new
    parser.allow_uneven_records = false
    result = parser.parse(%{foo,bar\nbaz})
    assert !result
    assert_equal :missing_fields, parser.failure_description
  end

  test "extra fields gets warning by default" do
    parser = CsvParser::CsvParser.new
    result = parser.parse(%{foo\nbar,baz})
    assert result, parser.failure_reason
    assert_equal [[:extra_fields, 2, 5]], parser.warnings
  end

  test "extra fields when disallowed" do
    parser = CsvParser::CsvParser.new
    parser.allow_uneven_records = false
    result = parser.parse(%{foo\nbar,baz})
    assert !result
    assert_equal :extra_fields, parser.failure_description
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

  test "custom quote character" do
    parser = CsvParser::CsvParser.new
    parser.quote_char = "'"
    result = parser.parse("'foo,bar'")
    assert result, parser.failure_reason
    assert_equal [['foo,bar']], result.value
  end

  test "parse helper" do
    result = CsvParser.parse("foo,bar")
    assert_equal [['foo', 'bar']], result.data
  end

  test "parse helper with options" do
    result = CsvParser.parse("foo\tbar", :field_sep => "\t")
    assert_equal [['foo', 'bar']], result.data
  end

  test "parse helper with missing closing quote" do
    error = nil
    begin
      CsvParser.parse(%{"foo})
    rescue CsvParser::MissingQuoteError => error
      assert_equal 1, error.line
      assert_equal 1, error.column
    end
    assert error
  end

  test "parse helper with stray quote" do
    error = nil
    begin
      CsvParser.parse(%{f"oo})
    rescue CsvParser::StrayQuoteError => error
      assert_equal 1, error.line
      assert_equal 2, error.column
    end
    assert error
  end

  test "parse helper with allowed short records" do
    result = CsvParser.parse(%{foo,bar\nbaz})
    assert_equal 1, result.warnings.length
    assert_kind_of CsvParser::MissingFieldsError, result.warnings[0]
    error = result.warnings[0]
    assert_equal 2, error.line
    assert_equal 4, error.column
  end

  test "parse helper with disallowed short records" do
    error = nil
    begin
      CsvParser.parse(%{foo,bar\nbaz}, :allow_uneven_records => false)
    rescue CsvParser::MissingFieldsError => error
      assert_equal 2, error.line
      assert_equal 4, error.column
    end
    assert error
  end

  test "parse helper with allowed long records" do
    result = CsvParser.parse(%{foo\nbar,baz})
    assert_equal 1, result.warnings.length
    assert_kind_of CsvParser::ExtraFieldsError, result.warnings[0]
    error = result.warnings[0]
    assert_equal 2, error.line
    assert_equal 5, error.column
  end

  test "parse helper with disallowed long records" do
    error = nil
    begin
      CsvParser.parse(%{foo\nbar,baz}, :allow_uneven_records => false)
    rescue CsvParser::ExtraFieldsError => error
      assert_equal 2, error.line
      assert_equal 5, error.column
    end
    assert error
  end
end
