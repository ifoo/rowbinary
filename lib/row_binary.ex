defmodule RowBinary do
  @moduledoc """
  `RowBinary` format encoding for ClickHouse.

  `RowBinary` is a binary format used to ingest data into ClickHouse efficiently. See https://clickhouse.yandex/docs/en/interfaces/formats/#rowbinary .

  You can either use `RowBinary.encode/2` to manually encode a field, or implement the `RowBinary.RowBinaryEncoding` protocol for your struct.

  ## Examples

        iex> RowBinary.encode(17, [:int8])
        <<17>>
  """

  use Bitwise

  defprotocol RowBinaryEncoding do
    @moduledoc ~S"""
    The `RowBinary.RowBinaryEncoding` protocol can be used to implement customer RowBinary encoders for structs.
    """

    @doc """
    Converts any struct into RowBinary format.
    """
    @spec encode(any) :: binary
    def encode(struct)
  end

  @doc """
  Encodes a single value into a binary in *RowBinary* format.

  You must provide the `value` you want to convert and a type definition in `types`.

  `types` must be a list, containing the type definitions including modifiers in order. For example,
  a `Array(Nullable(Uint8))` type would look like `[:array, :nullable, :uint8]`.

  Some types require an additional argument. For example, the `FixedString` type requires the byte size:
  A `Nullable(FixedString(16))` would look like this: `[:nullable, :fixedstring, 16]`.

  ## Examples

        iex> RowBinary.encode(17, [:int8])
        <<17>>


        iex> RowBinary.encode("hello", [:enum8, %{"hello" => 0, "world" => 1}])
        <<0>>


        iex> RowBinary.encode(["foo", nil, "barbazbarbaz"], [:array, :nullable, :fixedstring, 8])
        <<3, 0, 102, 111, 111, 0, 0, 0, 0, 0, 1, 0, 98, 97, 114, 98, 97, 122, 98, 97>>


        iex> RowBinary.encode(1337, [:int8]) # 1137 is out of range for 8 bit integers
        ** (ArgumentError) value=1337 with wrong types=[:int8]

  ## Supported types

    * `:int8`: Signed 8 bit `integer`
    * `:int16`: Signed 16 bit `integer`
    * `:int32`: Signed 32 bit `integer`
    * `:int64`: Signed 64 bit `integer`
    * `:uint8`: Unsigned 8 bit `integer`
    * `:uint16`: Unsigned 16 bit `integer`
    * `:uint32`: Unsigned 32 bit `integer`
    * `:uint64`: Unsigned 64 bit `integer`
    * `:float32`: 32 bit `float`
    * `:float64`: 64 bit `float`
    * `:date`: Elixir `Date` type
    * `:datetime`: Elixir `DateTime` type
    * `:string`: Elixir `binary`
    * `:fixedstring`: Elixir binary. Needs `byte size` as parameter
    * `:ipv4`: IPv4 tuple in the format `{_,_,_,_}` as returned by `:inet.parse_ipv4_address/1`
    * `:ipv6`: IPv6 tuple in the format `{_,_,_,_,_,_,_,_}` as returned by `:inet.parse_ipv6_address/1`
    * `:uuid`: UUID value as binary, as returned by `UUID.uuid4/1`
    * `:enum8`: A 8 bit enum type. Needs a mapping as parameter
    * `:enum16`: A 16 bit enum type. Needs a mapping as parameter
    * `:nullable`: Marks a subsequent type as `Nullable` and accepts `nil` as value
    * `:array`: Defines an subsequent type as `Array(T)`. Need a list as value

  Currently `Decimal` and  `AggregateFunction` types are not implemented.
  `Nested` types also don't have a specific type, but can be handled manually, via `:array` types. See https://clickhouse.yandex/docs/en/data_types/nested_data_structures/nested/ .

  Enums (`:enum8` and `:enum16`) require a mapping as parameter. You should use a `Map` structure as a translation table.
  The following example will map the `"hello"` string to the value `0` and encode it as an 8 bit integer:

        iex> RowBinary.encode("hello", [:enum8, %{"hello" => 0, "world" => 1}])
        <<0>>

  Note that currently not all type combinations are checked correctly. Things like `Nullable(Array(Int8))` (`[:nullable, :array, :int8]`) are not allowed in Clickhouse.

  The function returns a binary that is in RowBinary format. If errros are encountered (e.g. integer overflows, UUID parsing, Date or DateTime overflows, ...) an `ArgumentError` exception is raised.
  """
  def encode(value, types) when is_list(types) do
    RowBinary.Encode.encode(value, types)
  end
end
