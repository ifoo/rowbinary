defmodule RowBinaryTest do
  use ExUnit.Case
  doctest RowBinary

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

  test "Int8" do
    for n <- @int8_min..@int8_max do
      assert RowBinary.encode(n, [:int8]) == <<n>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int8_max + 1, [:int8])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int8_min - 1, [:int8])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:int8])
    end
  end

  test "Nullable(Int8)" do
    for n <- @int8_min..@int8_max do
      assert RowBinary.encode(n, [:nullable, :int8]) == <<0, n>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int8_max + 1, [:nullable, :int8])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int8_min - 1, [:nullable, :int8])
    end

    assert RowBinary.encode(nil, [:nullable, :int8]) == <<1>>
  end

  test "Int16" do
    for n <- @int16_min..@int16_max do
      assert RowBinary.encode(n, [:int16]) == <<n::little-signed-size(16)>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int16_max + 1, [:int16])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int16_min - 1, [:int16])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:int16])
    end
  end

  test "Nullable(Int16)" do
    for n <- @int16_min..@int16_max do
      assert RowBinary.encode(n, [:nullable, :int16]) == <<0, n::little-signed-size(16)>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int16_max + 1, [:nullable, :int16])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int16_min - 1, [:nullable, :int16])
    end

    assert RowBinary.encode(nil, [:nullable, :int16]) == <<1>>
  end

  test "Int32" do
    assert RowBinary.encode(@int32_min, [:int32]) == <<@int32_min::little-signed-size(32)>>
    assert RowBinary.encode(0, [:int32]) == <<0::little-signed-size(32)>>
    assert RowBinary.encode(@int32_max, [:int32]) == <<@int32_max::little-signed-size(32)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int32_max + 1, [:int32])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int32_min - 1, [:int32])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:int32])
    end
  end

  test "Nullable(Int32)" do
    assert RowBinary.encode(@int32_min, [:nullable, :int32]) ==
             <<0, @int32_min::little-signed-size(32)>>

    assert RowBinary.encode(0, [:nullable, :int32]) == <<0, 0::little-signed-size(32)>>

    assert RowBinary.encode(@int32_max, [:nullable, :int32]) ==
             <<0, @int32_max::little-signed-size(32)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int32_max + 1, [:nullable, :int32])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int32_min - 1, [:nullable, :int32])
    end

    assert RowBinary.encode(nil, [:nullable, :int32]) == <<1>>
  end

  test "Int64" do
    assert RowBinary.encode(@int64_min, [:int64]) == <<@int64_min::little-signed-size(64)>>
    assert RowBinary.encode(0, [:int64]) == <<0::little-signed-size(64)>>
    assert RowBinary.encode(@int64_max, [:int64]) == <<@int64_max::little-signed-size(64)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int64_max + 1, [:int64])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int64_min - 1, [:int64])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:int64])
    end
  end

  test "Nullable(Int64)" do
    assert RowBinary.encode(@int64_min, [:nullable, :int64]) ==
             <<0, @int64_min::little-signed-size(64)>>

    assert RowBinary.encode(0, [:nullable, :int64]) == <<0, 0::little-signed-size(64)>>

    assert RowBinary.encode(@int64_max, [:nullable, :int64]) ==
             <<0, @int64_max::little-signed-size(64)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int64_max + 1, [:nullable, :int64])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@int64_min - 1, [:nullable, :int64])
    end

    assert RowBinary.encode(nil, [:nullable, :int64]) == <<1>>
  end

  #### UINT

  test "UInt8" do
    for n <- @uint8_min..@uint8_max do
      assert RowBinary.encode(n, [:uint8]) == <<n>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint8_max + 1, [:uint8])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint8_min - 1, [:uint8])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:uint8])
    end
  end

  test "Nullable(UInt8)" do
    for n <- @uint8_min..@uint8_max do
      assert RowBinary.encode(n, [:nullable, :uint8]) == <<0, n>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint8_max + 1, [:nullable, :uint8])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint8_min - 1, [:nullable, :uint8])
    end

    assert RowBinary.encode(nil, [:nullable, :uint8]) == <<1>>
  end

  test "UInt16" do
    for n <- @uint16_min..@uint16_max do
      assert RowBinary.encode(n, [:uint16]) == <<n::little-unsigned-size(16)>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint16_max + 1, [:uint16])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint16_min - 1, [:uint16])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:uint16])
    end
  end

  test "Nullable(UInt16)" do
    for n <- @uint16_min..@uint16_max do
      assert RowBinary.encode(n, [:nullable, :uint16]) == <<0, n::little-unsigned-size(16)>>
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint16_max + 1, [:nullable, :uint16])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint16_min - 1, [:nullable, :uint16])
    end

    assert RowBinary.encode(nil, [:nullable, :uint16]) == <<1>>
  end

  test "UInt32" do
    assert RowBinary.encode(@uint32_min, [:uint32]) == <<@uint32_min::little-unsigned-size(32)>>
    assert RowBinary.encode(0, [:uint32]) == <<0::little-unsigned-size(32)>>
    assert RowBinary.encode(@uint32_max, [:uint32]) == <<@uint32_max::little-unsigned-size(32)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint32_max + 1, [:uint32])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint32_min - 1, [:uint32])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:uint32])
    end
  end

  test "Nullable(UInt32)" do
    assert RowBinary.encode(@uint32_min, [:nullable, :uint32]) ==
             <<0, @uint32_min::little-unsigned-size(32)>>

    assert RowBinary.encode(0, [:nullable, :uint32]) == <<0, 0::little-unsigned-size(32)>>

    assert RowBinary.encode(@uint32_max, [:nullable, :uint32]) ==
             <<0, @uint32_max::little-unsigned-size(32)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint32_max + 1, [:nullable, :uint32])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint32_min - 1, [:nullable, :uint32])
    end

    assert RowBinary.encode(nil, [:nullable, :uint32]) == <<1>>
  end

  test "UInt64" do
    assert RowBinary.encode(@uint64_min, [:uint64]) == <<@uint64_min::little-unsigned-size(64)>>
    assert RowBinary.encode(0, [:uint64]) == <<0::little-unsigned-size(64)>>
    assert RowBinary.encode(@uint64_max, [:uint64]) == <<@uint64_max::little-unsigned-size(64)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint64_max + 1, [:uint64])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint64_min - 1, [:uint64])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:uint64])
    end
  end

  test "Nullable(UInt64)" do
    assert RowBinary.encode(@uint64_min, [:nullable, :uint64]) ==
             <<0, @uint64_min::little-unsigned-size(64)>>

    assert RowBinary.encode(0, [:nullable, :uint64]) == <<0, 0::little-unsigned-size(64)>>

    assert RowBinary.encode(@uint64_max, [:nullable, :uint64]) ==
             <<0, @uint64_max::little-unsigned-size(64)>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint64_max + 1, [:nullable, :uint64])
    end

    assert_raise ArgumentError, fn ->
      RowBinary.encode(@uint64_min - 1, [:nullable, :uint64])
    end

    assert RowBinary.encode(nil, [:nullable, :uint64]) == <<1>>
  end

  test "Float32" do
    assert RowBinary.encode(0.0, [:float32]) == <<0.0::signed-little-float-32>>
    assert RowBinary.encode(1337.1337, [:float32]) == <<1337.1337::signed-little-float-32>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:float32])
    end
  end

  test "Nullable(Float32)" do
    assert RowBinary.encode(0.0, [:nullable, :float32]) == <<0, 0.0::signed-little-float-32>>

    assert RowBinary.encode(1337.1337, [:nullable, :float32]) ==
             <<0, 1337.1337::signed-little-float-32>>

    assert RowBinary.encode(nil, [:nullable, :float32]) == <<1>>
  end

  test "Float64" do
    assert RowBinary.encode(0.0, [:float64]) == <<0.0::signed-little-float-64>>
    assert RowBinary.encode(1337.1337, [:float64]) == <<1337.1337::signed-little-float-64>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(nil, [:float64])
    end
  end

  test "Nullable(Float64)" do
    assert RowBinary.encode(0.0, [:nullable, :float64]) == <<0, 0.0::signed-little-float-64>>

    assert RowBinary.encode(1337.1337, [:nullable, :float64]) ==
             <<0, 1337.1337::signed-little-float-64>>

    assert RowBinary.encode(nil, [:nullable, :float64]) == <<1>>
  end

  test "Date" do
    assert RowBinary.encode(~D[2020-01-15], [:date]) == <<0x64, 0x47>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(~D[1920-01-15], [:date])
    end
  end

  test "Nullable(Date)" do
    assert RowBinary.encode(~D[2020-01-15], [:nullable, :date]) == <<0, 0x64, 0x47>>
    assert RowBinary.encode(nil, [:nullable, :date]) == <<1>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(~D[1920-01-15], [:nullable, :date])
    end
  end

  test "DateTime" do
    assert RowBinary.encode(~U[2020-01-15 14:52:44.791915Z], [:datetime]) == <<60, 39, 31, 94>>
    assert RowBinary.encode(~U[2020-01-15 14:52:44.999999Z], [:datetime]) == <<60, 39, 31, 94>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(~U[1920-01-15 14:52:44.999999Z], [:datetime])
    end
  end

  test "Nullable(DateTime)" do
    assert RowBinary.encode(~U[2020-01-15 14:52:44.791915Z], [:nullable, :datetime]) ==
             <<0, 60, 39, 31, 94>>

    assert RowBinary.encode(~U[2020-01-15 14:52:44.999999Z], [:nullable, :datetime]) ==
             <<0, 60, 39, 31, 94>>

    assert_raise ArgumentError, fn ->
      RowBinary.encode(~U[1920-01-15 14:52:44.999999Z], [:nullable, :datetime])
    end

    assert RowBinary.encode(nil, [:nullable, :datetime]) == <<1>>
  end
end
