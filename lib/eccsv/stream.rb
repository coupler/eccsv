module ECCSV
  class Stream
    attr_reader :line, :col, :pos

    def initialize(io)
      @io = io
      @line = 1
      @col = 1
      @pos = 0
      @inserts = Hash.new { |h, k| h[k] = {} }
      @deletions = Hash.new { |h, k| h[k] = {} }
    end

    def peek
      unless defined? @buf
        @buf = getc
      end
      @buf
    end

    def next
      if defined? @buf
        val = @buf
        remove_instance_variable(:@buf)
      else
        val = getc
      end

      if val
        if val == "\n"
          @line += 1
          @col = 1
        else
          @col += 1
        end
        @pos += val.bytesize
      end
      val
    end

    def eof?
      peek.nil?
    end

    def insert(str, line, col)
      i = 0
      str.each_char do |c|
        @inserts[line][col+i] = c
        if c == "\n"
          line += 1
          col = 1
          i = 0
        else
          i += 1
        end
      end
    end

    def delete(len, line, col)
      @deletions[line][col] = len
    end

    private

    def getc
      if @deletions.has_key?(@line) && @deletions[@line].has_key?(@col)
        @io.seek(@deletions[@line][@col], IO::SEEK_CUR)
      end

      if @inserts.has_key?(@line) && @inserts[@line].has_key?(@col)
        @inserts[@line][@col]
      else
        @io.getc
      end
    end
  end
end
