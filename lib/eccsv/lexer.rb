module ECCSV
  class Lexer
    def initialize(stream)
      @stream = stream
    end

    def next_token
      unless @stream.eof?
        token = nil
        match = ""
        line = @stream.line
        col = @stream.col

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
        node = Node.new(match, token, line, col)
        [token, node]
      end
    end
  end
end
