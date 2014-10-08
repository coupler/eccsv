module ECCSV
  class Stream
    attr_reader :line, :col

    def initialize(io)
      @io = io
      @line = 1
      @col = 1
    end

    def peek
      unless defined? @buf
        @buf = @io.getc
      end
      @buf
    end

    def next
      if defined? @buf
        val = @buf
        remove_instance_variable(:@buf)
      else
        val = @io.getc
      end

      if val
        if val == "\n"
          @line += 1
          @col = 1
        else
          @col += 1
        end
      end
      val
    end

    def eof?
      @io.eof? && !defined? @buf
    end
  end
end
