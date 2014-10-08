module ECCSV
  class Lexer
    attr_reader :line, :col

    def initialize(string)
      @stream = Stream.new(StringIO.new(string))
      @line = 1
      @col = 1
    end

    def next_token
      unless @stream.eof?
        next_line = @line
        next_col = @col
        token = nil
        match = ""

        until @stream.eof?
          c = @stream.peek
          if token.nil?
            match << c
            @stream.next
            if c == ","
              token = :COMMA
              break
            elsif c == '"'
              token = :QUOTE
              break
            elsif c == "\n"
              token = :NEWLINE
              next_line += 1
              next_col = 0
              break
            else
              token = :TEXT
            end
          elsif c != "," && c != '"' && c != "\n"
            match << c
            @stream.next
          else
            break
          end
        end

        if match.length == 0
          raise "Stream error"
        end

        next_col += match.length

        node = Node.new(match, token, @line, @col)
        @line = next_line
        @col = next_col
        [token, node]
      end
    end
  end
end
