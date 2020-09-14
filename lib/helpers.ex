defmodule RowBinary.Helpers do
  @moduledoc false

  use Bitwise

  @compile {:inline, [encode_leb128: 1]}
  def encode_leb128(v) when v < 128, do: <<v>>
  def encode_leb128(v), do: <<1::1, v::7, encode_leb128(v >>> 7)::binary>>

  @compile {:inline, [to_int: 1]}
  # Hex character to integer.
  defp to_int(c) when ?0 <= c and c <= ?9 do
    c - ?0
  end

  defp to_int(c) when ?A <= c and c <= ?F do
    c - ?A + 10
  end

  defp to_int(c) when ?a <= c and c <= ?f do
    c - ?a + 10
  end

  defp hex_str_to_list([]) do
    []
  end

  defp hex_str_to_list([x, y | tail]) do
    [to_int(x) * 16 + to_int(y) | hex_str_to_list(tail)]
  end

  @compile {:inline, [uuid_string_to_hex_pair: 1]}
  def uuid_string_to_hex_pair(<<uuid::binary>>) do
    uuid = String.downcase(uuid)

    {type, hex_str} =
      case uuid do
        <<u0::64, ?-, u1::32, ?-, u2::32, ?-, u3::32, ?-, u4::96>> ->
          {:default, <<u0::64, u1::32, u2::32, u3::32, u4::96>>}

        <<u::256>> ->
          {:hex, <<u::256>>}

        <<"urn:uuid:", u0::64, ?-, u1::32, ?-, u2::32, ?-, u3::32, ?-, u4::96>> ->
          {:urn, <<u0::64, u1::32, u2::32, u3::32, u4::96>>}

        _ ->
          raise ArgumentError, message: "Invalid argument; Not a valid UUID: #{uuid}"
      end

    try do
      <<hex::128>> =
        :binary.bin_to_list(hex_str)
        |> hex_str_to_list
        |> IO.iodata_to_binary()

      {type, <<hex::128>>}
    catch
      _, _ ->
        raise ArgumentError, message: "Invalid argument; Not a valid UUID: #{uuid}"
    end
  end
end
