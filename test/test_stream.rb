require 'helper'

class TestStream < Test::Unit::TestCase
  test "#peek returns 1 character without advancing cursor" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    assert_equal "f", stream.peek
    assert_equal "f", stream.peek
    assert_equal "f", stream.peek
  end

  test "#next advances cursor" do
    io = StringIO.new("foo")
    stream = ECCSV::Stream.new(io)
    assert_equal "f", stream.peek
    stream.next
    assert_equal "o", stream.peek
    stream.next
    assert_equal "o", stream.peek
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
