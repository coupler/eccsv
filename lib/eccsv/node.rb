module ECCSV
  class Node
    attr_reader :value, :token, :line, :col

    def initialize(value = "", token = nil, line = nil, col = nil)
      @value = value
      @token = token
      @line = line
      @col = col
    end
  end

  class ParentNode < Node
    def initialize(children = [], line = nil, col = nil)
      last = children.last
      if last && last.is_a?(Node)
        line = last.line
        col = last.col
      end
      super(nil, nil, line, col)
      @children = children
    end
  end

  class QuotedTextNode < ParentNode
    def value
      @value ||= @children.collect(&:value).join
    end
  end

  class FieldNode < ParentNode
    def value
      @value ||=
        if @children[0].token == :TEXT
          @children[0].value
        else
          # quoted text
          @children[1].value
        end
    end
  end

  class DelimFieldNode < ParentNode
    def value
      @value ||= @children[0].value
    end
  end

  class DelimFieldsNode < ParentNode
    def value
      @value ||=
        if @children.empty?
          []
        else
          @children[0].value + [@children[1].value]
        end
    end
  end

  class RecordNode < ParentNode
    def value
      # TODO: 'consume' children to produce value to reduce memory footprint
      @value ||= @children[0].value + [@children[1].value]
    end
  end

  class DelimRecordNode < ParentNode
    def value
      @value ||= @children.length == 1 ? [] : @children[0].value
    end
  end

  class DelimRecordsNode < ParentNode
    def value
      if @value.nil?
        if @children.empty?
          @value = []
        else
          @value = @children[0].value
          val = @children[1].value
          if !val.empty?
            @value += [val]
          end
        end
      end
      @value
    end
  end

  class RootNode < ParentNode
    def value
      if @value.nil?
        @value = @children[0].value
        if @children[1]
          @value += [@children[1].value]
        end
      end
      @value
    end
  end
end
