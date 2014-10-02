module ECCSV
  class Error < Exception
    attr_reader :line, :col

    def initialize(msg = nil, line = nil, col = nil)
      super(msg)
      @line = line
      @col = col
    end
  end

  class UnmatchedQuoteError < Error; end
  class StrayQuoteError < Error; end
  class MissingFieldsError < Error; end
  class ExtraFieldsError < Error; end
end
