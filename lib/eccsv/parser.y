class Parser
  token NEWLINE COMMA TEXT QUOTE

rule
  root: delim_records        { result = root(val).value }
      | delim_records record { result = root(val).value }

  delim_records:                            { result = delim_records }
               | delim_records delim_record { result = delim_records(val) }

  delim_record: NEWLINE        { result = delim_record(val) }
              | record NEWLINE { result = delim_record(val) }

  # TODO: reduce record nodes
  record: delim_fields field { result = record(val) }

  delim_fields:                          { result = delim_fields }
              | delim_fields delim_field { result = delim_fields(val) }

  delim_field: field COMMA { result = delim_field(val) }

  field: QUOTE quoted_text QUOTE { result = field(val) }
       | TEXT                    { result = field(val) }

  quoted_text:                     { result = quoted_text }
             | quoted_text COMMA   { result = quoted_text(val) }
             | quoted_text NEWLINE { result = quoted_text(val) }
             | quoted_text TEXT    { result = quoted_text(val) }
end

---- header
require 'strscan'

module ECCSV
---- inner
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

  attr_reader :error

  def parse(str)
    @scanner = StringScanner.new(str)
    @line = 1
    @col = 1
    do_parse
  end

  def next_token
    until @scanner.empty?
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

      value = node(match, token)
      @line = next_line
      @col = next_col

      return [token, value]
    end
  end

  def warnings
    @warnings ||= []
  end

  private

  def node(value = "", token = nil, line = @line, col = @col)
    Node.new(value, token, line, col)
  end

  def quoted_text(children = [], line = @line, col = @col)
    QuotedTextNode.new(children, line, col)
  end

  def field(children = [], line = @line, col = @col)
    FieldNode.new(children, line, col)
  end

  def delim_field(children = [], line = @line, col = @col)
    DelimFieldNode.new(children, line, col)
  end

  def delim_fields(children = [], line = @line, col = @col)
    DelimFieldsNode.new(children, line, col)
  end

  def record(children = [], line = @line, col = @col)
    record = RecordNode.new(children, line, col)
    value = record.value
    if defined? @num_fields
      first = children[0]
      line = first.line
      col = first.col
      if @num_fields > value.length
        msg = "expected %d more fields on line %d" % [@num_fields - value.length, line]
        self.warnings.push(MissingFieldsError.new(msg, line, col))
      elsif @num_fields < value.length
        msg = "%d extra fields found on line %d, column %d" % [value.length - @num_fields, line, col]
        self.warnings.push(ExtraFieldsError.new(msg, line, col))
      end
    else
      @num_fields = value.length
    end

    record
  end

  def delim_record(children = [], line = @line, col = @col)
    DelimRecordNode.new(children, line, col)
  end

  def delim_records(children = [], line = @line, col = @col)
    DelimRecordsNode.new(children, line, col)
  end

  def root(children = [], line = @line, col = @col)
    RootNode.new(children, line, col)
  end

  def on_error(t, val, stack)
    #pp t
    #pp val
    #pp stack

    # figure out what error we have
    if t == 0
      # unexpected EOF
      type = nil
      stack.reverse_each do |node|
        case node
        when QuotedTextNode
          type = :unmatched_quote
        when Node
          if type == :unmatched_quote && node.token == :QUOTE
            line = node.line
            col = node.col
            @error = UnmatchedQuoteError.new("unmatched quote at line #{line}, column #{col}", line, col)
          end
        end
      end

      if @error.nil?
        @error = Error.new("unexpected EOF")
      end
    elsif val.is_a?(Node) && val.token == :QUOTE
      line = val.line
      col = val.col
      @error = StrayQuoteError.new("stray quote at line #{line}, column #{col}", line, col)
    end
  end
---- footer
end
