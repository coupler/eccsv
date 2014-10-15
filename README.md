# ECCSV

ECCSV (error correcting comma seperated values) is a CSV parsing library with
advanced error reporting and correcting.

## Installation

Add this line to your application's Gemfile:

    gem 'eccsv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eccsv

## Basic Usage

```ruby
require 'eccsv'

data = <<EOF
foo,bar
baz,qux
EOF

parser = ECCSV::Parser.new
parser.parse(data) #=> [["foo", "bar"], ["baz", "qux"]]
```

## Errors

One of the goals of this project is to give you descriptive error messages.

Each error type is a subclass of `ECCSV::Error` and contains the exact line
number (via `Error#line`) and column number (via `Error#col`) where the error
took place.

* missing closing quote (`ECCSV::UnmatchedQuoteError`)
* quote in the wrong place (`ECCSV::StrayQuoteError`)
* rows with not enough fields (`ECCSV::MissingFieldsError`)
* rows with too many fields (`ECCSV::ExtraFieldsError`)

Since missing/extra fields do not cause the CSV to be unparsable, they are
treated as warnings instead of errors (see example below).

### Examples

#### Unmatched quote

If there was an error, `#parse` will return `nil` and set `#error`.

```ruby
require 'eccsv'

data = <<EOF
foo,"bar
baz,qux
EOF

parser = ECCSV::Parser.new
parser.parse(data) #=> nil
parser.error       #=> #<ECCSV::UnmatchedQuoteError: unmatched quote at line 1, column 5>
parser.error.line  #=> 1
parser.error.col   #=> 5
```

#### Missing fields

If there was a warning, `#parse` will return the records and add to `#warnings`.

```ruby
require 'eccsv'

data = <<EOF
foo,bar
baz
EOF

parser = ECCSV::Parser.new
parser.parse(data)      #=> [["foo", "bar"], ["baz"]]
parser.warnings         #=> [#<ECCSV::MissingFieldsError: expected 1 more fields on line 2>]
parser.warnings[0].line #=> 2
parser.warnings[0].col  #=> 4
```

#### Extra fields

```ruby
require 'eccsv'

data = <<EOF
foo
bar,baz
EOF

parser = ECCSV::Parser.new
parser.parse(data)      #=> [["foo"], ["bar", "baz"]]
parser.warnings         #=> [#<ECCSV::ExtraFieldsError: 1 extra fields found on line 2, column 4>]
parser.warnings[0].line #=> 2
parser.warnings[0].col  #=> 4
```

## Corrections

It is possible to provide corrections to errors by inserting and deleting.

### Examples

#### Inserting

```ruby
require 'eccsv'

data = <<EOF
foo",bar
EOF

parser = ECCSV::Parser.new
parser.add_correction(1, 1, :insert, '"')
parser.parse(data)      #=> [["foo", "bar"]]]
```

#### Deleting

```ruby
require 'eccsv'

data = <<EOF
foo",bar
EOF

parser = ECCSV::Parser.new
parser.add_correction(1, 4, :delete, 1)
parser.parse(data)      #=> [["foo", "bar"]]]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
