defmodule RowBinary.Encode do
  use Bitwise

  @moduledoc false

  @int8_min -0x7F - 1
  @int8_max 0x7F

  @int16_min -0x7FFF - 1
  @int16_max 0x7FFF

  @int32_min -0x7FFFFFFF - 1
  @int32_max 0x7FFFFFFF

  @int64_min -0x7FFFFFFFFFFFFFFF - 1
  @int64_max 0x7FFFFFFFFFFFFFFF

  @uint8_min 0
  @uint8_max @int8_max * 2 + 1

  @uint16_min 0
  @uint16_max @int16_max * 2 + 1

  @uint32_min 0
  @uint32_max @int32_max * 2 + 1

  @uint64_min 0
  @uint64_max @int64_max * 2 + 1

  # TODO: add type checking logic
  def encode(_, []), do: raise(ArgumentError, message: "Missing type definition")

  def encode(value, types) when is_list(types) do
    do_encode(value, types)
  end

  # ARRAYS

  defp do_encode(value, [:array | rest]) when is_list(value) do
    RowBinary.Helpers.encode_leb128(length(value)) <>
      (Enum.map(value, &encode(&1, rest)) |> :binary.list_to_bin())
  end

  # NULLABLES
  defp do_encode(nil, [:nullable | _rest]), do: <<1::8>>

  defp do_encode(value, [:nullable | rest]), do: <<0::8>> <> encode(value, rest)

  # INTEGERS

  defp do_encode(value, [:int8])
       when is_integer(value) and value >= @int8_min and value <= @int8_max,
       do: <<value::little-signed-size(8)>>

  defp do_encode(value, [:int16])
       when is_integer(value) and value >= @int16_min and value <= @int16_max,
       do: <<value::little-signed-size(16)>>

  defp do_encode(value, [:int32])
       when is_integer(value) and value >= @int32_min and value <= @int32_max,
       do: <<value::little-signed-size(32)>>

  defp do_encode(value, [:int64])
       when is_integer(value) and value >= @int64_min and value <= @int64_max,
       do: <<value::little-signed-size(64)>>

  # UNSIGNED INTEGERS

  defp do_encode(value, [:uint8])
       when is_integer(value) and value >= @uint8_min and value <= @uint8_max,
       do: <<value::little-unsigned-size(8)>>

  defp do_encode(value, [:uint16])
       when is_integer(value) and value >= @uint16_min and value <= @uint16_max,
       do: <<value::little-unsigned-size(16)>>

  defp do_encode(value, [:uint32])
       when is_integer(value) and value >= @uint32_min and value <= @uint32_max,
       do: <<value::little-unsigned-size(32)>>

  defp do_encode(value, [:uint64])
       when is_integer(value) and value >= @uint64_min and value <= @uint64_max,
       do: <<value::little-unsigned-size(64)>>

  # FLOATS

  defp do_encode(value, [:float32]) when is_float(value), do: <<value::signed-little-float-32>>

  defp do_encode(value, [:float64]) when is_float(value), do: <<value::signed-little-float-64>>

  # DATE

  defp do_encode(%Date{} = value, [:date]) do
    value
    |> Date.to_erl()
    |> :calendar.date_to_gregorian_days()
    |> Kernel.-(719_528)
    |> do_encode([:uint16])
  end

  # DATETIME

  defp do_encode(%DateTime{} = value, [:datetime]) do
    value
    |> DateTime.to_unix(:second)
    |> do_encode([:uint32])
  end

  # STRINGS

  defp do_encode(value, [:string]) when is_binary(value) do
    len =
      value
      |> byte_size
      |> RowBinary.Helpers.encode_leb128()

    len <> <<value::bytes>>
  end

  # FIXEDSTRING

  defp do_encode(value, [:fixedstring, size])
       when is_binary(value) and is_integer(size) and size > 0 do
    l = byte_size(value)

    cond do
      l == size ->
        <<value::binary>>

      l > size ->
        binary_part(value, 0, size)

      l < size ->
        padding_bits = 8 * (size - l)
        binary_part(value, 0, l) <> <<0::size(padding_bits)>>
    end
  end

  # IPv4

  defp do_encode({a, b, c, d} = _value, [:ipv4])
       when is_integer(a) and is_integer(b) and is_integer(c) and is_integer(d) and
              a >= @uint8_min and
              a <= @uint8_max and b >= @uint8_min and b <= @uint8_max and c >= @uint8_min and
              c <= @uint8_max and d >= @uint8_min and d <= @uint8_max do
    (a <<< 24 ||| b <<< 16 ||| c <<< 8 ||| d)
    |> do_encode([:uint32])
  end

  # IPv6

  defp do_encode({a, b, c, d, e, f, g, h} = _value, [:ipv6])
       when is_integer(a) and is_integer(b) and is_integer(c) and is_integer(d) and is_integer(e) and
              is_integer(f) and is_integer(g) and is_integer(h) and a >= @uint16_min and
              a <= @uint16_max and
              b >= @uint16_min and b <= @uint16_max and
              c >= @uint16_min and c <= @uint16_max and
              d >= @uint16_min and d <= @uint16_max and
              e >= @uint16_min and e <= @uint16_max and
              f >= @uint16_min and f <= @uint16_max and
              g >= @uint16_min and g <= @uint16_max and
              h >= @uint16_min and h <= @uint16_max do
    <<a::big-unsigned-size(16)>> <>
      <<b::big-unsigned-size(16)>> <>
      <<c::big-unsigned-size(16)>> <>
      <<d::big-unsigned-size(16)>> <>
      <<e::big-unsigned-size(16)>> <>
      <<f::big-unsigned-size(16)>> <>
      <<g::big-unsigned-size(16)>> <> <<h::big-unsigned-size(16)>>
  end

  # UUID

  defp do_encode(value, [:uuid]) when is_binary(value) do
    {_, <<a::64, b::64>>} = RowBinary.Helpers.uuid_string_to_hex_pair(value)
    do_encode(a, [:uint64]) <> do_encode(b, [:uint64])
  end

  # ENUM

  defp do_encode(value, [:enum8, mapping]) when is_binary(value) and is_map(mapping) do
    case Map.get(mapping, value) do
      nil -> raise ArgumentError, message: "#{value} is not a valid enum8"
      int -> do_encode(int, [:int8])
    end
  end

  defp do_encode(value, [:enum16, mapping]) when is_binary(value) and is_map(mapping) do
    case Map.get(mapping, value) do
      nil -> raise ArgumentError, message: "#{value} is not a valid enum16"
      int -> do_encode(int, [:int16])
    end
  end

  # TODO: add DECIMAL support

  # TODO: add AggregateFunction support

  # FALLBACK

  defp do_encode(value, types) do
    raise ArgumentError, message: "value=#{inspect(value)} with wrong types=#{inspect(types)}"
  end
end
