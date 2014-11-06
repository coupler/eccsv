require 'helper'

class TestParser < Test::Unit::TestCase
  def parse(string)
    parser = ECCSV::Parser.new
    parser.parse(string)
  end

  test "one record with two fields" do
    assert_equal [['foo', 'bar']], parse("foo,bar")
  end

  test "one record with one field" do
    assert_equal [['foo']], parse("foo")
  end

  test "empty records" do
    assert_equal [], parse("")
  end

  test "empty record is skipped by default" do
    assert_equal [['foo'], ['bar']], parse("foo\n\nbar")
  end

  test "skipping empty record at end" do
    assert_equal [['foo'], ['bar']], parse("foo\nbar\n")
  end

=begin
  test "not skipping an empty record" do
    parser = ECCSV::Parser.new
    parser.skip_empty_record = false
    result = parser.parse("foo\n\nbar")
    assert_equal [['foo'], [], ['bar']], result.value
  end

  test "not skipping empty record at end" do
    parser = ECCSV::Parser.new
    parser.skip_empty_record = false
    result = parser.parse("foo\nbar\n")
    assert_equal [['foo'], ['bar'], []], result.value
  end
=end

  test "two records" do
    assert_equal [['foo', 'bar'], ['baz', 'qux']], parse("foo,bar\nbaz,qux")
  end

  test "quoted field" do
    assert_equal [["foo,bar"]], parse(%{"foo,bar"})
  end

  test "missing closing quote" do
    parser = ECCSV::Parser.new
    result = parser.parse(%{foo,bar\n"foo})
    assert !result
    assert_kind_of ECCSV::UnmatchedQuoteError, parser.error
    assert_equal 2, parser.error.line
    assert_equal 1, parser.error.col
  end

  test "quote inside unquoted field" do
    parser = ECCSV::Parser.new
    result = parser.parse(%{f"oo})
    assert !result
    assert_kind_of ECCSV::StrayQuoteError, parser.error
    assert_equal 1, parser.error.line
    assert_equal 2, parser.error.col
  end

  test "missing fields gets warning by default" do
    parser = ECCSV::Parser.new
    result = parser.parse(%{foo,bar\nbaz})
    assert_equal [['foo', 'bar'], ['baz']], result
    assert_equal 1, parser.warnings.length
    warning = parser.warnings[0]
    assert_kind_of ECCSV::MissingFieldsError, warning
    assert_equal 2, warning.line
    assert_equal 4, warning.col
  end

=begin
  test "missing fields when disallowed" do
    parser = ECCSV::Parser.new
    parser.allow_uneven_records = false
    result = parser.parse(%{foo,bar\nbaz})
    assert !result
    assert_equal :missing_fields, parser.failure_type
  end
=end

  test "extra fields gets warning by default" do
    parser = ECCSV::Parser.new
    result = parser.parse(%{foo\nbar,baz})
    assert_equal [['foo'], ['bar', 'baz']], result
    assert_equal 1, parser.warnings.length
    warning = parser.warnings[0]
    assert_kind_of ECCSV::ExtraFieldsError, warning
    assert_equal 2, warning.line
    assert_equal 4, warning.col
  end

=begin
  test "extra fields when disallowed" do
    parser = ECCSV::Parser.new
    parser.allow_uneven_records = false
    result = parser.parse(%{foo\nbar,baz})
    assert !result
    assert_equal :extra_fields, parser.failure_type
  end

  test "single-character custom field separator" do
    parser = ECCSV::Parser.new
    parser.field_sep = "\t"
    result = parser.parse("foo\tbar")
    assert result, parser.failure_reason
    assert_equal [['foo', 'bar']], result.value
  end

  test "multi-character custom field separator" do
    parser = ECCSV::Parser.new
    parser.field_sep = "foo"
    result = parser.parse("bazfoobar")
    assert result, parser.failure_reason
    assert_equal [['baz', 'bar']], result.value
  end

  test "single-character custom record separator" do
    parser = ECCSV::Parser.new
    parser.record_sep = "x"
    result = parser.parse("fooxbar")
    assert result, parser.failure_reason
    assert_equal [['foo'], ['bar']], result.value
  end

  test "multi-character custom record separator" do
    parser = ECCSV::Parser.new
    parser.record_sep = "foo"
    result = parser.parse("barfoobaz")
    assert result, parser.failure_reason
    assert_equal [['bar'], ['baz']], result.value
  end

  test "custom quote character" do
    parser = ECCSV::Parser.new
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
      assert_equal "no ending quote found for quote on line 1, column 1", error.message
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
      assert_equal "invalid quote found on line 1, column 2", error.message
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
    assert_equal "record on line 2 had too few fields", error.message
  end

  test "parse helper with disallowed short records" do
    error = nil
    begin
      CsvParser.parse(%{foo,bar\nbaz}, :allow_uneven_records => false)
    rescue CsvParser::MissingFieldsError => error
      assert_equal 2, error.line
      assert_equal 4, error.column
      assert_equal "record on line 2 had too few fields", error.message
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
    assert_equal "record on line 2 had too many fields", error.message
  end

  test "parse helper with disallowed long records" do
    error = nil
    begin
      CsvParser.parse(%{foo\nbar,baz}, :allow_uneven_records => false)
    rescue CsvParser::ExtraFieldsError => error
      assert_equal 2, error.line
      assert_equal 5, error.column
      assert_equal "record on line 2 had too many fields", error.message
    end
    assert error
  end
=end

  test "single insertion correction" do
    parser = ECCSV::Parser.new
    parser.add_correction(2, 5, :insert, '"')
    result = parser.parse(%{foo,bar\n"foo})
    assert_equal [['foo', 'bar'], ['foo']], result
  end

  test "single deletion correction" do
    parser = ECCSV::Parser.new
    parser.add_correction(1, 1, :delete, 1)
    result = parser.parse(%{"foo,bar})
    assert_equal [['foo', 'bar']], result
  end

  test "parsing IO" do
    io = StringIO.new('foo')
    parser = ECCSV::Parser.new
    assert_equal [['foo']], parser.parse(io)
  end
end
