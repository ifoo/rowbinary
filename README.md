# RowBinary

Library for working with ClickHouse's [RowBinary](https://clickhouse.yandex/docs/en/interfaces/formats/#rowbinary "ClickHouse RowBinary Format") format. 

Currently, the library only supports encoding to *RowBinary* format. A decoder might be implemented later. 
This library is meant to be used for ingestion data into ClickHouse with Elixir efficiently.


## Installation

The package can be installed by adding `rowbinary` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rowbinary, "~> 0.1.0"}
  ]
end
```

## Usage

`RowBinary.encode/2` can be used to encode Elixir data into ClickHouse RowBinary-encoded binaries. Additionally, a protocol spec `RowBinary.RowBinaryEncoding` is included to help with implementing encoders for structs or maps.

### Examples:
```elixir
    iex> RowBinary.encode(17, [:int8])
    <<17>>


    iex> RowBinary.encode("hello", [:enum8, %{"hello" => 0, "world" => 1}])
    <<0>>


    iex> RowBinary.encode(["foo", nil, "barbazbarbaz"], [:array, :nullable, :fixedstring, 8])
    <<3, 0, 102, 111, 111, 0, 0, 0, 0, 0, 1, 0, 98, 97, 114, 98, 97, 122, 98, 97>>


    iex> RowBinary.encode(1337, [:int8]) # 1137 is out of range for 8 bit integers
    ** (ArgumentError) value=1337 with wrong types=[:int8]
```
`RowBinary.encode/2` takes a value that should be encoded and a type definition. See `RowBinary.encode/2` for information about supported types.

## Limitations

  * **Decimal** and **AggregateFunction** types are not supported
  * Type definitions are not checked before encoding. Types like *Nullable(Array(Int8))* are not allowed in ClickHouse, but `RowBinary.encode/2` will generate a result for now. Keep that in mind.

## Testing

  * Not all unit test are done yet, but will be gradually updated.
  * You can run `mix generate_test_cases` to generate ExUnit test cases with data directly pulled from a local ClickHouse server.


## Benchmarks

```
Name                                  ips        average  deviation         median         99th %
float32                           13.44 M       74.38 ns ±31997.44%          46 ns          97 ns
float64                           13.42 M       74.54 ns ±31437.63%          39 ns         173 ns
int16                             12.83 M       77.92 ns ±34046.24%          42 ns          93 ns
uint16                            12.23 M       81.78 ns ±32837.36%          43 ns         102 ns
uint8                             11.68 M       85.63 ns ±31902.38%          47 ns         115 ns
int32                             11.47 M       87.18 ns ±30597.14%          47 ns         107 ns
int8                              11.40 M       87.73 ns ±31150.32%          48 ns         118 ns
uint32                            10.93 M       91.48 ns ±30263.29%          52 ns         110 ns
int64                              8.97 M      111.50 ns ±21277.66%          82 ns         159 ns
uint64                             8.09 M      123.63 ns ±25362.26%          83 ns         264 ns
fixedstring_medium                 7.99 M      125.18 ns ±29659.83%          61 ns         103 ns
fixedstring_short                  7.49 M      133.54 ns ±29224.88%          61 ns          96 ns
enum16                             7.06 M      141.70 ns ±12062.72%         107 ns         185 ns
enum8                              6.81 M      146.92 ns ±12132.97%         109 ns         241 ns
int16_nullable                     6.26 M      159.70 ns ±19120.97%         101 ns         237 ns
float32_nullable                   6.25 M      159.91 ns ±19210.34%         101 ns         232 ns
uint8_nullable                     6.14 M      162.81 ns ±19420.34%         100 ns         350 ns
uint16_nullable                    6.04 M      165.56 ns ±18865.28%         108 ns         234 ns
int32_nullable                     6.01 M      166.30 ns ±18483.14%         106 ns         349 ns
int8_nullable                      5.85 M      170.89 ns ±19343.78%         105 ns         413 ns
float64_nullable                   5.64 M      177.17 ns ±19409.67%          99 ns         226 ns
fixedstring_nullable_short         5.61 M      178.26 ns ±18491.88%         125 ns         246 ns
ipv4                               5.48 M      182.52 ns  ±9926.33%         145 ns         211 ns
uint32_nullable                    5.46 M      183.14 ns ±17913.89%         109 ns         445 ns
uint64_nullable                    5.12 M      195.19 ns ±12095.99%         145 ns         344 ns
enum8_nullable                     4.37 M      228.63 ns ±13658.96%         169 ns         314 ns
enum16_nullable                    4.31 M      232.22 ns ±13503.33%         173 ns         329 ns
int64_nullable                     4.28 M      233.47 ns ±15233.64%         151 ns         323 ns
ipv6                               4.11 M      243.57 ns  ±5280.01%         216 ns         348 ns
ipv4_nullable                      3.67 M      272.79 ns ±11722.87%         207 ns         414 ns
string_medium                      3.61 M      276.79 ns   ±214.24%         251 ns         542 ns
string_short                       3.23 M      309.88 ns  ±5660.74%         186 ns        1738 ns
date                               2.79 M      358.03 ns  ±7836.94%         288 ns         611 ns
ipv6_nullable                      2.78 M      360.14 ns  ±9366.41%         279 ns         646 ns
string_large                       2.64 M      378.87 ns    ±53.17%         303 ns         615 ns
fixedstring_nullable_medium        2.59 M      385.93 ns ±11247.24%         199 ns         469 ns
date_nullable                      2.21 M      452.19 ns  ±8436.48%         350 ns         705 ns
string_nullable_short              2.19 M      456.62 ns  ±8237.23%         242 ns         774 ns
fixedstring_nullable_large         2.02 M      494.99 ns  ±6464.26%         247 ns        1475 ns
fixedstring_large                  1.96 M      509.81 ns  ±6193.13%         248 ns        1659 ns
datetime                           1.48 M      674.67 ns  ±4135.51%         585 ns        1000 ns
datetime_nullable                  1.33 M      752.78 ns  ±3806.41%         656 ns        1118 ns
string_nullable_medium             1.26 M      795.26 ns  ±4828.47%         384 ns        1191 ns
string_nullable_large              0.88 M     1136.22 ns  ±2881.13%         644 ns        1392 ns
array_short                        0.75 M     1331.87 ns  ±2054.50%        1044 ns        2544 ns
uuid_hex                           0.26 M     3827.59 ns   ±504.17%        3411 ns        6774 ns
uuid_hex_nullable                  0.26 M     3904.76 ns   ±537.69%        3472 ns        6772 ns
uuid_default                       0.25 M     3979.64 ns   ±359.59%        3551 ns        9099 ns
uuid_default_nullable              0.24 M     4089.80 ns   ±378.71%        3629 ns     9390.95 ns
array_long                        0.112 M     8946.26 ns   ±158.33%        8180 ns       18199 ns
array_large                      0.0121 M    82707.29 ns    ±29.05%       83042 ns    97103.83 ns
```
