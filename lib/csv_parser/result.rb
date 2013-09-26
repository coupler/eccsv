module CsvParser
  class Result
    attr_reader :data, :warnings
    def initialize(data, warnings)
      @data = data
      @warnings = warnings
    end
  end
end
