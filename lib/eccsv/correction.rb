module ECCSV
  class Correction
    attr_reader :line, :col

    def initialize(line, col, *args)
      @line = line
      @col = col
    end

    def apply(stream)
      raise NotImplementedError
    end
  end

  class InsertCorrection < Correction
    attr_reader :string

    def initialize(line, col, string)
      super
      @string = string
    end

    def length
      @string.length
    end

    def apply(stream)
      stream.insert(@string, @line, @col)
    end
  end

  class DeleteCorrection < Correction
    def initialize(line, col, amount)
      super
      @amount = amount
    end

    def apply(stream)
      stream.delete(@amount, @line, @col)
    end
  end
end
