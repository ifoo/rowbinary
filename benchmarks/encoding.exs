int8_min = -0x7F - 1
int8_max = 0x7F

int16_min = -0x7FFF - 1
int16_max = 0x7FFF

int32_min = -0x7FFFFFFF - 1
int32_max = 0x7FFFFFFF

int64_min = -0x7FFFFFFFFFFFFFFF - 1
int64_max = 0x7FFFFFFFFFFFFFFF

uint8_min = 0
uint8_max = int8_max * 2 + 1

uint16_min = 0
uint16_max = int16_max * 2 + 1

uint32_min = 0
uint32_max = int32_max * 2 + 1

uint64_min = 0
uint64_max = int64_max * 2 + 1


int8_value = int8_min..int8_max |> Enum.random
int16_value = int16_min..int16_max |> Enum.random
int32_value = int32_min..int32_max |> Enum.random
int64_value = int64_min..int64_max |> Enum.random

uint8_value = uint8_min..uint8_max |> Enum.random
uint16_value = uint16_min..uint16_max |> Enum.random
uint32_value = uint32_min..uint32_max |> Enum.random
uint64_value = uint64_min..uint64_max |> Enum.random


float_value = :rand.uniform()

string_short = "CzDQ2wBjiQ"
string_short_len = byte_size(string_short)

string_medium = "gOYTe31WGialOUHBzdvHTVJKLe82qaN9HXH1Iey2F5UoArCqATFyx0DqKzVfpv50KqE57UNPoMPDFw7040x3fzMXCURcvw82RokCh0IpNFXNcf3hBHWqZmQnfdKL7PG6"
string_medium_len = byte_size(string_medium)

string_large = "nrShlM8kkEOb08KWWlkNew1uWDGKPgvw33CHV8SMMY2yp0CADOhIi8GKs0m95ao1kipDauWJPhUHyZY5CGwuJ3OkI0UunTQoQKbYOuDpkquSegVBuXHTqitz80HMQTk2OdKou5WEvuGCWD0Sl178nki4VEoYtBOkuKVPISoDmF7DEgIK69xB2X9ZqBrvvY1yYnVJWcZGaLE4yhoDS6Vj6apCRkeTLhqoD4EWZgwslVuwb6Qf7xXLQcFVM6cUaQy3fIqg6l9gazWK2tpMXznppSkzYU3D1Tp7l6K4WQrR9KumjFFviksEZrKOp3GmVFsN1iu4z0BjkfP04ndjETz7EZyNlaVuNCwboh9rPrnMG0IKOs9K1WI2qnyLSGh1vhNKigB2NeSBmqAGoiu0aBDCEEWtMuXxBSRJVtrJGmmSiqCrJnZobsCOo5in1mbVerVFaDqpi2il9QaI6yfV9DDEmZVF0SM7V3nEsfFczhlvgmKUjEPk3xGnKZZSmHQT4sHuigzgHv5x5KgUWJup2Zrruhg9WHCVBKjSDWQagtJViYNP63QHjRF0YL71SGFWzgKQ2v9FyBtsDR8ugcxRGvlrrd11rcxnvJiZ8DmQZKL58Z1NLakAbav4IBCcMkzJX9VY2JlI9Whu2WUKAKd9QYxEq6bncoGpRhSRHKmMZuvp6YiEdKswY13iZNV1XBCe5NhgEowYoipfj33G4rqyxRu4cPRgQbFZTxnNaLsSZ2Ul6bpQBpaGl5kZkdtrwAM962Yf1dW5d9QZIEdk1VaZGy5lCs070x60PVYg3sqTu3ARIJDksWqLVP1270pOTS0hLWYt6w37OHPVAMBGaKYwUyvi22cjL3hYlxJphhdZ5haLVCk043NlV3RO1jxB7x9VOWttQ7oe3iLP9QdzK6qNqSM8DCrrv4KeWBFkEmoYGodtHiZSW8mQtpy3xZFEHDJgFg88b8NoVvoBYjWScWFXjOc5GyZe7vZbSsssO4MKw6zkavpPLoPmqOvuTccfn4LsM886"
string_large_len = byte_size(string_large)

date = Date.utc_today()
datetime = DateTime.utc_now()

ipv4 = {192, 168, 1, 1}
{:ok, ipv6} = :inet.parse_ipv6_address("2001:0db8:0000:0000:0000:8a2e:0370:7334" |> to_charlist)

uuid_default = UUID.uuid4(:default)
uuid_hex = UUID.uuid4(:hex)

enum_mapping = %{"hello" => 0, "world" => 1}

array_short = 1..10 |> Enum.to_list
array_long = 1..100 |> Enum.to_list
array_large = 1..1000 |> Enum.to_list


Benchee.run(
  %{
    "int8" => fn -> RowBinary.encode(int8_value, [:int8]) end,
    "int8_nullable" => fn -> RowBinary.encode(int8_value, [:nullable, :int8]) end,
    "int16" => fn -> RowBinary.encode(int16_value, [:int16]) end,
    "int16_nullable" => fn -> RowBinary.encode(int16_value, [:nullable, :int16]) end,
    "int32" => fn -> RowBinary.encode(int32_value, [:int32]) end,
    "int32_nullable" => fn -> RowBinary.encode(int32_value, [:nullable, :int32]) end,
    "int64" => fn -> RowBinary.encode(int64_value, [:int64]) end,
    "int64_nullable" => fn -> RowBinary.encode(int64_value, [:nullable, :int64]) end,

    "uint8" => fn -> RowBinary.encode(uint8_value, [:uint8]) end,
    "uint8_nullable" => fn -> RowBinary.encode(uint8_value, [:nullable, :uint8]) end,
    "uint16" => fn -> RowBinary.encode(uint16_value, [:uint16]) end,
    "uint16_nullable" => fn -> RowBinary.encode(uint16_value, [:nullable, :uint16]) end,
    "uint32" => fn -> RowBinary.encode(uint32_value, [:uint32]) end,
    "uint32_nullable" => fn -> RowBinary.encode(uint32_value, [:nullable, :uint32]) end,
    "uint64" => fn -> RowBinary.encode(uint64_value, [:uint64]) end,
    "uint64_nullable" => fn -> RowBinary.encode(uint64_value, [:nullable, :uint64]) end,

    "float32" => fn -> RowBinary.encode(float_value, [:float32]) end,
    "float32_nullable" => fn -> RowBinary.encode(float_value, [:nullable, :float32]) end,
    "float64" => fn -> RowBinary.encode(float_value, [:float64]) end,
    "float64_nullable" => fn -> RowBinary.encode(float_value, [:nullable, :float64]) end,

    "string_short" => fn -> RowBinary.encode(string_short, [:string]) end,
    "string_nullable_short" => fn -> RowBinary.encode(string_short, [:nullable, :string]) end,
    "fixedstring_short" => fn -> RowBinary.encode(string_short, [:fixedstring, string_short_len]) end,
    "fixedstring_nullable_short" => fn -> RowBinary.encode(string_short, [:nullable, :fixedstring, string_short_len]) end,

    "string_medium" => fn -> RowBinary.encode(string_medium, [:string]) end,
    "string_nullable_medium" => fn -> RowBinary.encode(string_medium, [:nullable, :string]) end,
    "fixedstring_medium" => fn -> RowBinary.encode(string_medium, [:fixedstring, string_medium_len]) end,
    "fixedstring_nullable_medium" => fn -> RowBinary.encode(string_medium, [:nullable, :fixedstring, string_medium_len]) end,

    "string_large" => fn -> RowBinary.encode(string_large, [:string]) end,
    "string_nullable_large" => fn -> RowBinary.encode(string_large, [:nullable, :string]) end,
    "fixedstring_large" => fn -> RowBinary.encode(string_large, [:nullable, :fixedstring, string_large_len]) end,
    "fixedstring_nullable_large" => fn -> RowBinary.encode(string_large, [:nullable, :fixedstring, string_large_len]) end,

    "date" => fn -> RowBinary.encode(date, [:date]) end,
    "date_nullable" => fn -> RowBinary.encode(date, [:nullable, :date]) end,

    "datetime" => fn -> RowBinary.encode(datetime, [:datetime]) end,
    "datetime_nullable" => fn -> RowBinary.encode(datetime, [:nullable, :datetime]) end,

    "ipv4" => fn -> RowBinary.encode(ipv4, [:ipv4]) end,
    "ipv4_nullable" => fn -> RowBinary.encode(ipv4, [:nullable, :ipv4]) end,

    "ipv6" => fn -> RowBinary.encode(ipv6, [:ipv6]) end,
    "ipv6_nullable" => fn -> RowBinary.encode(ipv6, [:nullable, :ipv6]) end,

    "uuid_default" => fn -> RowBinary.encode(uuid_default, [:uuid]) end,
    "uuid_default_nullable" => fn -> RowBinary.encode(uuid_default, [:nullable, :uuid]) end,

    "uuid_hex" => fn -> RowBinary.encode(uuid_hex, [:uuid]) end,
    "uuid_hex_nullable" => fn -> RowBinary.encode(uuid_hex, [:nullable, :uuid]) end,

    "enum8" => fn -> RowBinary.encode("hello", [:enum8, enum_mapping]) end,
    "enum8_nullable" => fn -> RowBinary.encode("hello", [:nullable, :enum8, enum_mapping]) end,

    "enum16" => fn -> RowBinary.encode("hello", [:enum16, enum_mapping]) end,
    "enum16_nullable" => fn -> RowBinary.encode("hello", [:nullable, :enum16, enum_mapping]) end,

    "array_short" => fn -> RowBinary.encode(array_short, [:array, :uint32]) end,
    "array_long" => fn -> RowBinary.encode(array_long, [:array, :uint32]) end,
    "array_large" => fn -> RowBinary.encode(array_large, [:array, :uint32]) end,
  }
)
