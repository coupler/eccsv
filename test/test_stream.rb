require 'helper'

class TestStream < Test::Unit::TestCase
  test "#peek returns 1 character without advancing cursor" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    assert_equal "f", stream.peek
    assert_equal "f", stream.peek
    assert_equal "f", stream.peek
  end

  test "#next advances cursor after peek" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    assert_equal "f", stream.peek
    stream.next
    assert_equal "o", stream.peek
    stream.next
    assert_equal "o", stream.peek
  end

  test "#next advances cursor without peek" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    stream.next
    assert_equal "o", stream.peek
  end

  test "#next increases column" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    assert_equal 1, stream.col
    stream.next
    assert_equal 2, stream.col
    stream.next
    assert_equal 3, stream.col
  end

  test "#next increases line and resets column after reaching newline" do
    io = StringIO.new("f\noo")
    stream = ECCSV::Stream.new(io)
    assert_equal 1, stream.line
    assert_equal 1, stream.col
    stream.next
    assert_equal 1, stream.line
    assert_equal 2, stream.col
    stream.next
    assert_equal 2, stream.line
    assert_equal 1, stream.col
  end

  test "#eof? returns true if at end" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    stream.peek
    stream.next
    stream.peek
    stream.next
    stream.peek
    stream.next
    assert stream.eof?
  end
end