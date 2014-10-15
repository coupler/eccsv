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

  test "#next increases pos for single-byte character" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    assert_equal 0, stream.pos
    stream.next
    assert_equal 1, stream.pos
  end

  test "#next increases pos for multi-byte character" do
    io = StringIO.new("♫")
    stream = ECCSV::Stream.new(io)
    assert_equal 0, stream.pos
    stream.next
    assert_equal 3, stream.pos
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

  test "#insert at line and col" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    stream.insert("x", 1, 2)
    assert_equal "f", stream.next
    assert_equal "x", stream.next
    assert_equal "o", stream.next
    assert_equal "o", stream.next
  end

  test "#insert at end of input" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    stream.insert("x", 1, 4)
    assert_equal "f", stream.next
    assert_equal "o", stream.next
    assert_equal "o", stream.next
    assert !stream.eof?
    assert_equal "x", stream.next
  end

  test "#insert multi-character string" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    stream.insert("bar", 1, 2)
    assert_equal "f", stream.next
    assert_equal "b", stream.next
    assert_equal "a", stream.next
    assert_equal "r", stream.next
    assert_equal "o", stream.next
    assert_equal "o", stream.next
  end

  test "#insert newline" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    stream.insert("bar\nbaz", 1, 2)
    assert_equal "f", stream.next
    assert_equal "b", stream.next
    assert_equal "a", stream.next
    assert_equal "r", stream.next
    assert_equal "\n", stream.next
    assert_equal "b", stream.next
    assert_equal "a", stream.next
    assert_equal "z", stream.next
    assert_equal "o", stream.next
    assert_equal "o", stream.next
  end
end
