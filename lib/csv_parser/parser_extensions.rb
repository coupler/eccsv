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

    def quote_char
      @quote_char ||= '"'
    end

    def quote_char=(str)
      @quote_char = str
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

    def skip_empty_record?
      if defined? @skip_empty_record
        @skip_empty_record
      else
        true
      end
    end

    def skip_empty_record=(bool)
      @skip_empty_record = bool
    end

    def allow_uneven_records?
      if defined? @allow_uneven_records
        @allow_uneven_records
      else
        true
      end
    end

    def allow_uneven_records=(bool)
      @allow_uneven_records = bool
    end

    def failure_description
      @failure_description
    end

    def failure_index
      @failure_index || super
    end

    def warnings
      @warnings ||= []
    end
  end
end
