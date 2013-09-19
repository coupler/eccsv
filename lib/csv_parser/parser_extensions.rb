module CsvParser
  module ParserExtensions
    def field_sep
      @field_sep ||= ','
    end

    def field_sep=(str)
      @field_sep = str
    end
  end
end
