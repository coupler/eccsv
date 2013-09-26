# Autogenerated from a Treetop grammar. Edits may be lost.


module CsvParser
  module Csv
    include Treetop::Runtime

    def root
      @root ||= :records
    end

    include ParserExtensions

    def _nt_records
      start_index = index
      if node_cache[:records].has_key?(index)
        cached = node_cache[:records][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0 = index
      r1 = _nt_non_empty_records
      if r1
        r0 = r1
      else
        r2 = _nt_empty_records
        if r2
          r0 = r2
        else
          @index = i0
          r0 = nil
        end
      end

      node_cache[:records][start_index] = r0

      r0
    end

    module NonEmptyRecords0
      def first_record
        elements[0]
      end

      def other_records
        elements[1]
      end
    end

    module NonEmptyRecords1
      def value
        arr = [first_record.value]
        arr.push(*other_records.value)
        arr
      end
    end

    def _nt_non_empty_records
      start_index = index
      if node_cache[:non_empty_records].has_key?(index)
        cached = node_cache[:non_empty_records][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_first_record
      s0 << r1
      if r1
        r2 = _nt_other_records
        s0 << r2
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(NonEmptyRecords0)
        r0.extend(NonEmptyRecords1)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:non_empty_records][start_index] = r0

      r0
    end

    module EmptyRecords0
      def value
        []
      end
    end

    def _nt_empty_records
      start_index = index
      if node_cache[:empty_records].has_key?(index)
        cached = node_cache[:empty_records][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      if has_terminal?('', false, index)
        r0 = instantiate_node(SyntaxNode,input, index...(index + 0))
        r0.extend(EmptyRecords0)
        @index += 0
      else
        terminal_parse_failure('')
        r0 = nil
      end

      node_cache[:empty_records][start_index] = r0

      r0
    end

    module FirstRecord0
      def non_empty_record
        elements[2]
      end

    end

    module FirstRecord1
      def value
        non_empty_record.value
      end
    end

    def _nt_first_record
      start_index = index
      if node_cache[:first_record].has_key?(index)
        cached = node_cache[:first_record][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('', false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 0))
        @index += 0
      else
        terminal_parse_failure('')
        r1 = nil
      end
      s0 << r1
      if r1
        i2 = index
        r3 = lambda { |s| @first_record = true; true }.call(s0)
        if r3
          @index = i2
          r2 = instantiate_node(SyntaxNode,input, index...index)
        else
          r2 = nil
        end
        s0 << r2
        if r2
          r4 = _nt_non_empty_record
          s0 << r4
          if r4
            i5 = index
            r6 = lambda { |s| @first_record_length = @record_length; true }.call(s0)
            if r6
              @index = i5
              r5 = instantiate_node(SyntaxNode,input, index...index)
            else
              r5 = nil
            end
            s0 << r5
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(FirstRecord0)
        r0.extend(FirstRecord1)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:first_record][start_index] = r0

      r0
    end

    module OtherRecords0
    end

    module OtherRecords1
      def record_sep
        elements[0]
      end

      def record
        elements[2]
      end
    end

    module OtherRecords2
    end

    module OtherRecords3
      def value
        elements[2].elements.collect { |elt| elt.record.value }
      end
    end

    def _nt_other_records
      start_index = index
      if node_cache[:other_records].has_key?(index)
        cached = node_cache[:other_records][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('', false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 0))
        @index += 0
      else
        terminal_parse_failure('')
        r1 = nil
      end
      s0 << r1
      if r1
        i2 = index
        r3 = lambda { |s| @first_record = false; true }.call(s0)
        if r3
          @index = i2
          r2 = instantiate_node(SyntaxNode,input, index...index)
        else
          r2 = nil
        end
        s0 << r2
        if r2
          s4, i4 = [], index
          loop do
            i5, s5 = index, []
            r6 = _nt_record_sep
            s5 << r6
            if r6
              i8, s8 = index, []
              i9 = index
              r10 = lambda { |s| skip_empty_record? }.call(s8)
              if r10
                @index = i9
                r9 = instantiate_node(SyntaxNode,input, index...index)
              else
                r9 = nil
              end
              s8 << r9
              if r9
                s11, i11 = [], index
                loop do
                  r12 = _nt_record_sep
                  if r12
                    s11 << r12
                  else
                    break
                  end
                end
                r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
                s8 << r11
              end
              if s8.last
                r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
                r8.extend(OtherRecords0)
              else
                @index = i8
                r8 = nil
              end
              if r8
                r7 = r8
              else
                r7 = instantiate_node(SyntaxNode,input, index...index)
              end
              s5 << r7
              if r7
                r13 = _nt_record
                s5 << r13
              end
            end
            if s5.last
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              r5.extend(OtherRecords1)
            else
              @index = i5
              r5 = nil
            end
            if r5
              s4 << r5
            else
              break
            end
          end
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          s0 << r4
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(OtherRecords2)
        r0.extend(OtherRecords3)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:other_records][start_index] = r0

      r0
    end

    def _nt_record
      start_index = index
      if node_cache[:record].has_key?(index)
        cached = node_cache[:record][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0 = index
      r1 = _nt_non_empty_record
      if r1
        r0 = r1
      else
        r2 = _nt_empty_record
        if r2
          r0 = r2
        else
          @index = i0
          r0 = nil
        end
      end

      node_cache[:record][start_index] = r0

      r0
    end

    module NonEmptyRecord0
      def field_sep
        elements[1]
      end

      def field
        elements[2]
      end

    end

    module NonEmptyRecord1
      def first
        elements[0]
      end

      def rest
        elements[2]
      end

    end

    module NonEmptyRecord2
      def value
        arr = [first.value]
        rest.elements.each do |elt|
          arr << elt.field.value
        end
        arr
      end
    end

    def _nt_non_empty_record
      start_index = index
      if node_cache[:non_empty_record].has_key?(index)
        cached = node_cache[:non_empty_record][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_field
      s0 << r1
      if r1
        i2 = index
        r3 = lambda { |s| @record_length = 1; true }.call(s0)
        if r3
          @index = i2
          r2 = instantiate_node(SyntaxNode,input, index...index)
        else
          r2 = nil
        end
        s0 << r2
        if r2
          s4, i4 = [], index
          loop do
            i5, s5 = index, []
            i6 = index
            r7 = lambda { |s|
                      if @first_record || allow_uneven_records? || @record_length < @first_record_length
                        true
                      else
                        @failure_description = :extra_fields
                        false
                      end
                    }.call(s5)
            if r7
              @index = i6
              r6 = instantiate_node(SyntaxNode,input, index...index)
            else
              r6 = nil
            end
            s5 << r6
            if r6
              r8 = _nt_field_sep
              s5 << r8
              if r8
                r9 = _nt_field
                s5 << r9
                if r9
                  i10 = index
                  r11 = lambda { |s| @record_length += 1; true }.call(s5)
                  if r11
                    @index = i10
                    r10 = instantiate_node(SyntaxNode,input, index...index)
                  else
                    r10 = nil
                  end
                  s5 << r10
                end
              end
            end
            if s5.last
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              r5.extend(NonEmptyRecord0)
            else
              @index = i5
              r5 = nil
            end
            if r5
              s4 << r5
            else
              break
            end
          end
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          s0 << r4
          if r4
            i12 = index
            r13 = lambda { |s|
                    if @first_record || allow_uneven_records? || @record_length == @first_record_length
                      true
                    else
                      @failure_description = :missing_fields
                      false
                    end
                  }.call(s0)
            if r13
              @index = i12
              r12 = instantiate_node(SyntaxNode,input, index...index)
            else
              r12 = nil
            end
            s0 << r12
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(NonEmptyRecord1)
        r0.extend(NonEmptyRecord2)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:non_empty_record][start_index] = r0

      r0
    end

    module EmptyRecord0
    end

    module EmptyRecord1
      def value
        []
      end
    end

    def _nt_empty_record
      start_index = index
      if node_cache[:empty_record].has_key?(index)
        cached = node_cache[:empty_record][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('', false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 0))
        @index += 0
      else
        terminal_parse_failure('')
        r1 = nil
      end
      s0 << r1
      if r1
        i2 = index
        r3 = lambda { |s|
                if allow_empty_record?
                  true
                else
                  @failure_description = :missing_fields
                  false
                end
              }.call(s0)
        if r3
          @index = i2
          r2 = instantiate_node(SyntaxNode,input, index...index)
        else
          r2 = nil
        end
        s0 << r2
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(EmptyRecord0)
        r0.extend(EmptyRecord1)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:empty_record][start_index] = r0

      r0
    end

    module Field0
      def value
        elements.map(&:text_value).join
      end
    end

    module Field1
      def value
        elements[1..-2].map(&:text_value).join
      end
    end

    def _nt_field
      start_index = index
      if node_cache[:field].has_key?(index)
        cached = node_cache[:field][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0 = index
      r1 = _nt_unquoted_text
      r1.extend(Field0)
      if r1
        r0 = r1
      else
        r2 = _nt_quoted_text
        r2.extend(Field1)
        if r2
          r0 = r2
        else
          @index = i0
          r0 = nil
        end
      end

      node_cache[:field][start_index] = r0

      r0
    end

    module QuotedText0
    end

    module QuotedText1
    end

    module QuotedText2
      def quote
        elements[0]
      end

    end

    def _nt_quoted_text
      start_index = index
      if node_cache[:quoted_text].has_key?(index)
        cached = node_cache[:quoted_text][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_quote
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          i3, s3 = index, []
          i4 = index
          r5 = _nt_quote
          if r5
            r4 = nil
          else
            @index = i4
            r4 = instantiate_node(SyntaxNode,input, index...index)
          end
          s3 << r4
          if r4
            if index < input_length
              r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("any character")
              r6 = nil
            end
            s3 << r6
          end
          if s3.last
            r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
            r3.extend(QuotedText0)
          else
            @index = i3
            r3 = nil
          end
          if r3
            s2 << r3
          else
            break
          end
        end
        if s2.empty?
          @index = i2
          r2 = nil
        else
          r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        end
        s0 << r2
        if r2
          i7 = index
          r8 = _nt_quote
          if r8
            r7 = r8
          else
            i9, s9 = index, []
            if has_terminal?('', false, index)
              r10 = instantiate_node(SyntaxNode,input, index...(index + 0))
              @index += 0
            else
              terminal_parse_failure('')
              r10 = nil
            end
            s9 << r10
            if r10
              i11 = index
              r12 = lambda { |s| @failure_description = :missing_quote; true }.call(s9)
              if r12
                r11 = nil
              else
                @index = i11
                r11 = instantiate_node(SyntaxNode,input, index...index)
              end
              s9 << r11
            end
            if s9.last
              r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
              r9.extend(QuotedText1)
            else
              @index = i9
              r9 = nil
            end
            if r9
              r7 = r9
            else
              @index = i7
              r7 = nil
            end
          end
          s0 << r7
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(QuotedText2)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:quoted_text][start_index] = r0

      r0
    end

    module UnquotedText0
    end

    module UnquotedText1
    end

    def _nt_unquoted_text
      start_index = index
      if node_cache[:unquoted_text].has_key?(index)
        cached = node_cache[:unquoted_text][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      s0, i0 = [], index
      loop do
        i1, s1 = index, []
        i2 = index
        r3 = _nt_field_sep
        if r3
          r2 = nil
        else
          @index = i2
          r2 = instantiate_node(SyntaxNode,input, index...index)
        end
        s1 << r2
        if r2
          i4 = index
          r5 = _nt_record_sep
          if r5
            r4 = nil
          else
            @index = i4
            r4 = instantiate_node(SyntaxNode,input, index...index)
          end
          s1 << r4
          if r4
            i6 = index
            i7 = index
            r8 = _nt_quote
            if r8
              r7 = nil
            else
              @index = i7
              r7 = instantiate_node(SyntaxNode,input, index...index)
            end
            if r7
              r6 = r7
            else
              i9, s9 = index, []
              if has_terminal?('', false, index)
                r10 = instantiate_node(SyntaxNode,input, index...(index + 0))
                @index += 0
              else
                terminal_parse_failure('')
                r10 = nil
              end
              s9 << r10
              if r10
                i11 = index
                r12 = lambda { |s| @failure_description = :stray_quote; true }.call(s9)
                if r12
                  r11 = nil
                else
                  @index = i11
                  r11 = instantiate_node(SyntaxNode,input, index...index)
                end
                s9 << r11
              end
              if s9.last
                r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
                r9.extend(UnquotedText0)
              else
                @index = i9
                r9 = nil
              end
              if r9
                r6 = r9
              else
                @index = i6
                r6 = nil
              end
            end
            s1 << r6
            if r6
              if index < input_length
                r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r13 = nil
              end
              s1 << r13
            end
          end
        end
        if s1.last
          r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          r1.extend(UnquotedText1)
        else
          @index = i1
          r1 = nil
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      if s0.empty?
        @index = i0
        r0 = nil
      else
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      end

      node_cache[:unquoted_text][start_index] = r0

      r0
    end

    module FieldSep0
    end

    module FieldSep1
    end

    def _nt_field_sep
      start_index = index
      if node_cache[:field_sep].has_key?(index)
        cached = node_cache[:field_sep][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      i1 = index
      r2 = lambda { |s| @field_sep_index = 0; true }.call(s0)
      if r2
        @index = i1
        r1 = instantiate_node(SyntaxNode,input, index...index)
      else
        r1 = nil
      end
      s0 << r1
      if r1
        s3, i3 = [], index
        loop do
          i4, s4 = index, []
          i5 = index
          r6 = _nt_record_sep
          if r6
            r5 = nil
          else
            @index = i5
            r5 = instantiate_node(SyntaxNode,input, index...index)
          end
          s4 << r5
          if r5
            i7 = index
            r8 = _nt_quote
            if r8
              r7 = nil
            else
              @index = i7
              r7 = instantiate_node(SyntaxNode,input, index...index)
            end
            s4 << r7
            if r7
              if index < input_length
                r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r9 = nil
              end
              s4 << r9
              if r9
                i10 = index
                r11 = lambda { |s|
                          if @field_sep_index < field_sep.length &&
                             s[2].text_value == field_sep[@field_sep_index]
                            @field_sep_index += 1
                            true
                          else
                            false
                          end
                        }.call(s4)
                if r11
                  @index = i10
                  r10 = instantiate_node(SyntaxNode,input, index...index)
                else
                  r10 = nil
                end
                s4 << r10
              end
            end
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(FieldSep0)
          else
            @index = i4
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        if s3.empty?
          @index = i3
          r3 = nil
        else
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        end
        s0 << r3
        if r3
          i12 = index
          r13 = lambda { |s| s.map(&:text_value).join == field_sep }.call(s0)
          if r13
            @index = i12
            r12 = instantiate_node(SyntaxNode,input, index...index)
          else
            r12 = nil
          end
          s0 << r12
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(FieldSep1)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:field_sep][start_index] = r0

      r0
    end

    module RecordSep0
    end

    module RecordSep1
    end

    def _nt_record_sep
      start_index = index
      if node_cache[:record_sep].has_key?(index)
        cached = node_cache[:record_sep][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      i1 = index
      r2 = lambda { |s| @record_sep_index = 0; true }.call(s0)
      if r2
        @index = i1
        r1 = instantiate_node(SyntaxNode,input, index...index)
      else
        r1 = nil
      end
      s0 << r1
      if r1
        s3, i3 = [], index
        loop do
          i4, s4 = index, []
          if index < input_length
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r5 = nil
          end
          s4 << r5
          if r5
            i6 = index
            r7 = lambda { |s|
                      if @record_sep_index < record_sep.length &&
                         s[0].text_value == record_sep[@record_sep_index]
                        @record_sep_index += 1
                        true
                      else
                        false
                      end
                    }.call(s4)
            if r7
              @index = i6
              r6 = instantiate_node(SyntaxNode,input, index...index)
            else
              r6 = nil
            end
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(RecordSep0)
          else
            @index = i4
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        if s3.empty?
          @index = i3
          r3 = nil
        else
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        end
        s0 << r3
        if r3
          i8 = index
          r9 = lambda { |s| s.map(&:text_value).join == record_sep }.call(s0)
          if r9
            @index = i8
            r8 = instantiate_node(SyntaxNode,input, index...index)
          else
            r8 = nil
          end
          s0 << r8
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(RecordSep1)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:record_sep][start_index] = r0

      r0
    end

    module Quote0
    end

    def _nt_quote
      start_index = index
      if node_cache[:quote].has_key?(index)
        cached = node_cache[:quote][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      i1 = index
      if has_terminal?("\\", false, index)
        r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("\\")
        r2 = nil
      end
      if r2
        r1 = nil
      else
        @index = i1
        r1 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r1
      if r1
        if has_terminal?('"', false, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r3 = nil
        end
        s0 << r3
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Quote0)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:quote][start_index] = r0

      r0
    end

  end

  class CsvParser < Treetop::Runtime::CompiledParser
    include Csv
  end

end
