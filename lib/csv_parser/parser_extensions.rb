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

    def allow_empty_record?
      if defined? @allow_empty_record
        @allow_empty_record
      else
        true
      end
    end

    def allow_empty_record=(bool)
      @allow_empty_record = bool
    end

    def failure_description
      @failure_description
    end
  end
end
