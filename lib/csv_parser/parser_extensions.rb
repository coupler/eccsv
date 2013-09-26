module CsvParser
  module ParserExtensions
    def field_sep
      @field_sep ||= ','
    end

    def field_sep=(str)
      @field_sep = str
    end

    def record_sep
      @record_sep ||= "\n"
    end

    def record_sep=(str)
      @record_sep = str
    end
  end
end
