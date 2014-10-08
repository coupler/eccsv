module ECCSV
  class Stream
    def initialize(io)
      @io = io
    end

    def peek
      unless defined? @buf
        @buf = @io.getc
      end
      @buf
    end

    def next
      remove_instance_variable(:@buf)
    end

    def eof?
      @io.eof? && !defined? @buf
    end
  end
end
