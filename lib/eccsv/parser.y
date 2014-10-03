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
  attr_reader :error, :warnings

  def initialize
    @warnings = []
  end

  def parse(str)
    @lexer = Lexer.new(str)
    do_parse
  end

  def curr_line
    @lexer.line
  end

  def curr_col
    @lexer.col
  end

  def next_token
    @lexer.next_token
  end

  def warnings
    @warnings ||= []
  end

  private

  def quoted_text(children = [], line = curr_line, col = curr_col)
    QuotedTextNode.new(children, line, col)
  end

  def field(children = [], line = curr_line, col = curr_col)
    FieldNode.new(children, line, col)
  end

  def delim_field(children = [], line = curr_line, col = curr_col)
    DelimFieldNode.new(children, line, col)
  end

  def delim_fields(children = [], line = curr_line, col = curr_col)
    DelimFieldsNode.new(children, line, col)
  end

  def record(children = [], line = curr_line, col = curr_col)
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

  def delim_record(children = [], line = curr_line, col = curr_col)
    DelimRecordNode.new(children, line, col)
  end

  def delim_records(children = [], line = curr_line, col = curr_col)
    DelimRecordsNode.new(children, line, col)
  end

  def root(children = [], line = curr_line, col = curr_col)
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
