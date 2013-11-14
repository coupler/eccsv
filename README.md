# CsvParser

CsvParser is a CSV parser that focuses on identifying errors.

## Installation

Add this line to your application's Gemfile:

    gem 'csv_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_parser

## Usage

CsvParser's goal is to give you descriptive error messages.

### Error types

* missing closing quote (`CsvParser::MissingQuoteError`)
* quote in the wrong place (`CsvParser::StrayQuoteError`)
* rows with not enough fields (`CsvParser::MissingFieldsError`)
* rows with too many fields (`CsvParser::ExtraFieldsError`)

### Options

You can pass in an options hash to the `CsvParser.parse` method
that contains one or more of the following options:

* `:field_sep` - specify field separator (default is `","`)
* `:record_sep` - specify record separator (default is `"\n"`)
* `:quote_char` - specify quote character (default is `"\""`)
* `:allow_empty_record` - specify whether empty records are allowed (default is `true`)
* `:skip_empty_record` - specify whether empty records are skipped (default is `true`)
* `:allow_uneven_records` - specify whether records with different field lengths are allowed (default is `true`)

### Example

```ruby
require 'csv_parser'

data = <<EOF
foo,"bar
baz,quz
EOF
begin
  result = CsvParser.parse(data)
rescue CsvParser::Error => e
  # e is a CsvParser::MissingQuoteError
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
