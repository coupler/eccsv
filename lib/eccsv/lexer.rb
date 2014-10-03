module ECCSV
  class Lexer
    attr_reader :line, :col

    def initialize(string)
      @scanner = StringScanner.new(string)
      @line = 1
      @col = 1
    end

    def next_token
      unless @scanner.empty?
        next_line = @line
        next_col = @col
        case
          when match = @scanner.scan(/,/)
            token = :COMMA
          when match = @scanner.scan(/"/)
            token = :QUOTE
          when match = @scanner.scan(/\n/)
            token = :NEWLINE
            next_line += 1
            next_col = 0
          when match = @scanner.scan(/[^,\n"]+/)
            token = :TEXT
          else
            raise "can't recognize <#{@scanner.peek(5)}>"
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
