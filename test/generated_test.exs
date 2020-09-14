defmodule RowBinaryTestGenerated do
  use ExUnit.Case

  alias RowBinary.Encode

  test "toInt8(16)" do
    assert Encode.encode(16, [:int8]) == <<16>>
  end

  test "toInt16(16)" do
    assert Encode.encode(16, [:int16]) == <<16, 0>>
  end

  test "toInt32(16)" do
    assert Encode.encode(16, [:int32]) == <<16, 0, 0, 0>>
  end

  test "toInt64(16)" do
    assert Encode.encode(16, [:int64]) == <<16, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "toNullable(toInt8(16))" do
    assert Encode.encode(16, [:nullable, :int8]) == <<0, 16>>
  end

  test "toNullable(toInt16(16))" do
    assert Encode.encode(16, [:nullable, :int16]) == <<0, 16, 0>>
  end

  test "toNullable(toInt32(16))" do
    assert Encode.encode(16, [:nullable, :int32]) == <<0, 16, 0, 0, 0>>
  end

  test "toNullable(toInt64(16))" do
    assert Encode.encode(16, [:nullable, :int64]) == <<0, 16, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "toNullable(toInt8(null))" do
    assert Encode.encode(nil, [:nullable, :int8]) == <<1>>
  end

  test "toNullable(toInt16(null))" do
    assert Encode.encode(nil, [:nullable, :int16]) == <<1>>
  end

  test "toNullable(toInt32(null))" do
    assert Encode.encode(nil, [:nullable, :int32]) == <<1>>
  end

  test "toNullable(toInt64(null))" do
    assert Encode.encode(nil, [:nullable, :int64]) == <<1>>
  end

  test "toUInt8(16)" do
    assert Encode.encode(16, [:uint8]) == <<16>>
  end

  test "toUInt16(16)" do
    assert Encode.encode(16, [:uint16]) == <<16, 0>>
  end

  test "toUInt32(16)" do
    assert Encode.encode(16, [:uint32]) == <<16, 0, 0, 0>>
  end

  test "toUInt64(16)" do
    assert Encode.encode(16, [:uint64]) == <<16, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "toNullable(toUInt8(16))" do
    assert Encode.encode(16, [:nullable, :int8]) == <<0, 16>>
  end

  test "toNullable(toUInt16(16))" do
    assert Encode.encode(16, [:nullable, :int16]) == <<0, 16, 0>>
  end

  test "toNullable(toUInt32(16))" do
    assert Encode.encode(16, [:nullable, :int32]) == <<0, 16, 0, 0, 0>>
  end

  test "toNullable(toUInt64(16))" do
    assert Encode.encode(16, [:nullable, :int64]) == <<0, 16, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "toNullable(toUInt8(null))" do
    assert Encode.encode(nil, [:nullable, :int8]) == <<1>>
  end

  test "toNullable(toUInt16(null))" do
    assert Encode.encode(nil, [:nullable, :int16]) == <<1>>
  end

  test "toNullable(toUInt32(null))" do
    assert Encode.encode(nil, [:nullable, :int32]) == <<1>>
  end

  test "toNullable(toUInt64(null))" do
    assert Encode.encode(nil, [:nullable, :int64]) == <<1>>
  end

  test "toFloat32(16.0)" do
    assert Encode.encode(16.0, [:float32]) == <<0, 0, 128, 65>>
  end

  test "toFloat64(16.0)" do
    assert Encode.encode(16.0, [:float64]) == <<0, 0, 0, 0, 0, 0, 48, 64>>
  end

  test "toNullable(toFloat32(16.0))" do
    assert Encode.encode(16.0, [:nullable, :float32]) == <<0, 0, 0, 128, 65>>
  end

  test "toNullable(toFloat64(16.0))" do
    assert Encode.encode(16.0, [:nullable, :float64]) == <<0, 0, 0, 0, 0, 0, 0, 48, 64>>
  end

  test "toNullable(toFloat32(null))" do
    assert Encode.encode(nil, [:nullable, :float32]) == <<1>>
  end

  test "toNullable(toFloat64(null))" do
    assert Encode.encode(nil, [:nullable, :float64]) == <<1>>
  end

  test "'helloworld'" do
    assert Encode.encode("helloworld", [:string]) == "\nhelloworld"
  end

  test "toNullable(toString('helloworld'))" do
    assert Encode.encode("helloworld", [:nullable, :string]) ==
             <<0, 10, 104, 101, 108, 108, 111, 119, 111, 114, 108, 100>>
  end

  test "toNullable(toString(null))" do
    assert Encode.encode(nil, [:nullable, :string]) == <<1>>
  end

  test "toFixedString('helloworld',16)" do
    assert Encode.encode("helloworld", [:fixedstring, 16]) ==
             <<104, 101, 108, 108, 111, 119, 111, 114, 108, 100, 0, 0, 0, 0, 0, 0>>
  end

  test "toNullable(toFixedString('helloworld',16))" do
    assert Encode.encode("helloworld", [:nullable, :fixedstring, 16]) ==
             <<0, 104, 101, 108, 108, 111, 119, 111, 114, 108, 100, 0, 0, 0, 0, 0, 0>>
  end

  test "toNullable(toFixedString(null,16))" do
    assert Encode.encode(nil, [:nullable, :fixedstring, 16]) == <<1>>
  end

  test "toDate(toDateTime('2016-06-15 23:00:00'))" do
    assert Encode.encode(~D[2016-06-15], [:date]) == "GB"
  end

  test "toNullable(toDate(toDateTime('2016-06-15 23:00:00')))" do
    assert Encode.encode(~D[2016-06-15], [:nullable, :date]) == <<0, 71, 66>>
  end

  test "toNullable(toDate(toDateTime(null)))" do
    assert Encode.encode(nil, [:nullable, :date]) == <<1>>
  end

  test "toDateTime('2016-06-15 23:00:00')" do
    assert Encode.encode(~U[2016-06-15 21:00:00.000000Z], [:datetime]) == <<208, 193, 97, 87>>
  end

  test "toNullable(toDateTime('2016-06-15 23:00:00'))" do
    assert Encode.encode(~U[2016-06-15 21:00:00.000000Z], [:nullable, :datetime]) ==
             <<0, 208, 193, 97, 87>>
  end

  test "toNullable(toDateTime(null))" do
    assert Encode.encode(nil, [:nullable, :datetime]) == <<1>>
  end

  test "toIPv4('192.168.1.1')" do
    assert Encode.encode({192, 168, 1, 1}, [:ipv4]) == <<1, 1, 168, 192>>
  end

  test "toNullable(toIPv4('192.168.1.1'))" do
    assert Encode.encode({192, 168, 1, 1}, [:nullable, :ipv4]) == <<0, 1, 1, 168, 192>>
  end

  test "toNullable(toIPv4(null))" do
    assert Encode.encode(nil, [:nullable, :ipv4]) == <<1>>
  end

  test "toIPv6('2001:0db8:0000:0000:0000:8a2e:0370:7334')" do
    assert Encode.encode({8193, 3512, 0, 0, 0, 35374, 880, 29492}, [:ipv6]) ==
             <<32, 1, 13, 184, 0, 0, 0, 0, 0, 0, 138, 46, 3, 112, 115, 52>>
  end

  test "toNullable(toIPv6('2001:0db8:0000:0000:0000:8a2e:0370:7334'))" do
    assert Encode.encode({8193, 3512, 0, 0, 0, 35374, 880, 29492}, [:nullable, :ipv6]) ==
             <<0, 32, 1, 13, 184, 0, 0, 0, 0, 0, 0, 138, 46, 3, 112, 115, 52>>
  end

  test "toNullable(toIPv6(null))" do
    assert Encode.encode(nil, [:nullable, :ipv6]) == <<1>>
  end

  test "toUUID('ad6614a6-86ce-4065-8d65-bd0999b24bbf')" do
    assert Encode.encode("ad6614a6-86ce-4065-8d65-bd0999b24bbf", [:uuid]) ==
             <<101, 64, 206, 134, 166, 20, 102, 173, 191, 75, 178, 153, 9, 189, 101, 141>>
  end

  test "toNullable(toUUID('ad6614a6-86ce-4065-8d65-bd0999b24bbf'))" do
    assert Encode.encode("ad6614a6-86ce-4065-8d65-bd0999b24bbf", [:nullable, :uuid]) ==
             <<0, 101, 64, 206, 134, 166, 20, 102, 173, 191, 75, 178, 153, 9, 189, 101, 141>>
  end

  test "toNullable(toUUID(null))" do
    assert Encode.encode(nil, [:nullable, :uuid]) == <<1>>
  end

  test "CAST('a', 'Enum8(\'a\' = 1, \'b\' = 2)')" do
    assert Encode.encode("a", [:enum8, %{"a" => 1, "b" => 2}]) == <<1>>
  end

  test "CAST('a', 'Nullable(Enum8(\'a\' = 1, \'b\' = 2))')" do
    assert Encode.encode("a", [:nullable, :enum8, %{"a" => 1, "b" => 2}]) == <<0, 1>>
  end

  test "CAST(null, 'Nullable(Enum8(\'a\' = 1, \'b\' = 2))')" do
    assert Encode.encode(nil, [:nullable, :enum8, %{"a" => 1, "b" => 2}]) == <<1>>
  end

  test "CAST('a', 'Enum16(\'a\' = 1, \'b\' = 2)')" do
    assert Encode.encode("a", [:enum16, %{"a" => 1, "b" => 2}]) == <<1, 0>>
  end

  test "CAST('a', 'Nullable(Enum16(\'a\' = 1, \'b\' = 2))')" do
    assert Encode.encode("a", [:nullable, :enum16, %{"a" => 1, "b" => 2}]) == <<0, 1, 0>>
  end

  test "CAST(null, 'Nullable(Enum16(\'a\' = 1, \'b\' = 2))')" do
    assert Encode.encode(nil, [:nullable, :enum16, %{"a" => 1, "b" => 2}]) == <<1>>
  end

  test "CAST([1,2,3], 'Array(Int8)')" do
    assert Encode.encode([1, 2, 3], [:array, :int8]) == <<3, 1, 2, 3>>
  end

  test "CAST([1,null,3], 'Array(Nullable(Int8))')" do
    assert Encode.encode([1, nil, 3], [:array, :nullable, :int8]) == <<3, 0, 1, 1, 0, 3>>
  end
end
