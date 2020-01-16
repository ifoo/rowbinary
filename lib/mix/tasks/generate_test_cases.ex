defmodule Mix.Tasks.GenerateTestCases do
  @moduledoc """
  This task can be used to generate test cases with real results from ClickHouse. The resulting test cases will be written to *./test/generated_test.exs*.

  The `@queries` attribute contains a list of CH select statements, that will be run, returned in *RowBinary* format and used to automatically generate test cases from them.
  The second tuple in the `@queries` attribute defines the parameters for the `RowBinary.encode/2` function.

  This requires a running ClickHouse server. Queries are run by starting `clickhouse-client` processes.
  Currently there is no option to provide parameters to `clickhouse-client` (e.g. hostname, user, password, ..).
  """
  use Mix.Task

  require Logger

  # TODO: elixir macros to directly generate test cases without the temporary files

  @queries [
    {"toInt8(16)", {16, [:int8]}},
    {"toInt16(16)", {16, [:int16]}},
    {"toInt32(16)", {16, [:int32]}},
    {"toInt64(16)", {16, [:int64]}},
    {"toNullable(toInt8(16))", {16, [:nullable, :int8]}},
    {"toNullable(toInt16(16))", {16, [:nullable, :int16]}},
    {"toNullable(toInt32(16))", {16, [:nullable, :int32]}},
    {"toNullable(toInt64(16))", {16, [:nullable, :int64]}},
    {"toNullable(toInt8(null))", {nil, [:nullable, :int8]}},
    {"toNullable(toInt16(null))", {nil, [:nullable, :int16]}},
    {"toNullable(toInt32(null))", {nil, [:nullable, :int32]}},
    {"toNullable(toInt64(null))", {nil, [:nullable, :int64]}},
    {"toUInt8(16)", {16, [:uint8]}},
    {"toUInt16(16)", {16, [:uint16]}},
    {"toUInt32(16)", {16, [:uint32]}},
    {"toUInt64(16)", {16, [:uint64]}},
    {"toNullable(toUInt8(16))", {16, [:nullable, :int8]}},
    {"toNullable(toUInt16(16))", {16, [:nullable, :int16]}},
    {"toNullable(toUInt32(16))", {16, [:nullable, :int32]}},
    {"toNullable(toUInt64(16))", {16, [:nullable, :int64]}},
    {"toNullable(toUInt8(null))", {nil, [:nullable, :int8]}},
    {"toNullable(toUInt16(null))", {nil, [:nullable, :int16]}},
    {"toNullable(toUInt32(null))", {nil, [:nullable, :int32]}},
    {"toNullable(toUInt64(null))", {nil, [:nullable, :int64]}},
    {"toFloat32(16.0)", {16.0, [:float32]}},
    {"toFloat64(16.0)", {16.0, [:float64]}},
    {"toNullable(toFloat32(16.0))", {16.0, [:nullable, :float32]}},
    {"toNullable(toFloat64(16.0))", {16.0, [:nullable, :float64]}},
    {"toNullable(toFloat32(null))", {nil, [:nullable, :float32]}},
    {"toNullable(toFloat64(null))", {nil, [:nullable, :float64]}},
    {"'helloworld'", {"helloworld", [:string]}},
    {"toNullable(toString('helloworld'))", {"helloworld", [:nullable, :string]}},
    {"toNullable(toString(null))", {nil, [:nullable, :string]}},
    {"toFixedString('helloworld',16)", {"helloworld", [:fixedstring, 16]}},
    {"toNullable(toFixedString('helloworld',16))", {"helloworld", [:nullable, :fixedstring, 16]}},
    {"toNullable(toFixedString(null,16))", {nil, [:nullable, :fixedstring, 16]}},

    # TODO: add more fixed string tests with shorter strings, padding, ...

    {"toDate(toDateTime('2016-06-15 23:00:00'))", {~D[2016-06-15], [:date]}},
    {"toNullable(toDate(toDateTime('2016-06-15 23:00:00')))",
     {~D[2016-06-15], [:nullable, :date]}},
    {"toNullable(toDate(toDateTime(null)))", {nil, [:nullable, :date]}},
    # FIXME: timezone crap (23:00 -> 21:00)
    {"toDateTime('2016-06-15 23:00:00')", {~U[2016-06-15 21:00:00.000000Z], [:datetime]}},
    {"toNullable(toDateTime('2016-06-15 23:00:00'))",
     {~U[2016-06-15 21:00:00.000000Z], [:nullable, :datetime]}},
    {"toNullable(toDateTime(null))", {nil, [:nullable, :datetime]}},
    {"toIPv4('192.168.1.1')", {{192, 168, 1, 1}, [:ipv4]}},
    {"toNullable(toIPv4('192.168.1.1'))", {{192, 168, 1, 1}, [:nullable, :ipv4]}},
    {"toNullable(toIPv4(null))", {nil, [:nullable, :ipv4]}},
    {"toIPv6('2001:0db8:0000:0000:0000:8a2e:0370:7334')",
     {{8193, 3512, 0, 0, 0, 35374, 880, 29492}, [:ipv6]}},
    {"toNullable(toIPv6('2001:0db8:0000:0000:0000:8a2e:0370:7334'))",
     {{8193, 3512, 0, 0, 0, 35374, 880, 29492}, [:nullable, :ipv6]}},
    {"toNullable(toIPv6(null))", {nil, [:nullable, :ipv6]}},
    {"toUUID('ad6614a6-86ce-4065-8d65-bd0999b24bbf')",
     {"ad6614a6-86ce-4065-8d65-bd0999b24bbf", [:uuid]}},
    {"toNullable(toUUID('ad6614a6-86ce-4065-8d65-bd0999b24bbf'))",
     {"ad6614a6-86ce-4065-8d65-bd0999b24bbf", [:nullable, :uuid]}},
    {"toNullable(toUUID(null))", {nil, [:nullable, :uuid]}},
    {"CAST('a', 'Enum8(\\'a\\' = 1, \\'b\\' = 2)')", {"a", [:enum8, %{"a" => 1, "b" => 2}]}},
    {"CAST('a', 'Nullable(Enum8(\\'a\\' = 1, \\'b\\' = 2))')",
     {"a", [:nullable, :enum8, %{"a" => 1, "b" => 2}]}},
    {"CAST(null, 'Nullable(Enum8(\\'a\\' = 1, \\'b\\' = 2))')",
     {nil, [:nullable, :enum8, %{"a" => 1, "b" => 2}]}},
    {"CAST('a', 'Enum16(\\'a\\' = 1, \\'b\\' = 2)')", {"a", [:enum16, %{"a" => 1, "b" => 2}]}},
    {"CAST('a', 'Nullable(Enum16(\\'a\\' = 1, \\'b\\' = 2))')",
     {"a", [:nullable, :enum16, %{"a" => 1, "b" => 2}]}},
    {"CAST(null, 'Nullable(Enum16(\\'a\\' = 1, \\'b\\' = 2))')",
     {nil, [:nullable, :enum16, %{"a" => 1, "b" => 2}]}},
    {"CAST([1,2,3], 'Array(Int8)')", {[1, 2, 3], [:array, :int8]}},
    {"CAST([1,null,3], 'Array(Nullable(Int8))')", {[1, nil, 3], [:array, :nullable, :int8]}}
  ]

  @doc false
  def run(_) do
    cases = generate_cases()
    compiled = EEx.eval_file("./lib/mix/tasks/testcase.eex", cases: cases)
    :ok = File.write!("./test/generated_test.exs", compiled)
  end

  defp generate_cases do
    stream =
      Task.async_stream(@queries, fn {query, data} ->
        full_query = "select #{query} format RowBinary"
        Logger.info("Running query: #{inspect(full_query)} -> #{inspect(data)}")

        {query, data, run_query(full_query)}
      end)

    Enum.to_list(stream) |> Enum.map(fn {:ok, result} -> result end)
  end

  defp run_query(query) when is_binary(query) do
    case System.cmd("clickhouse-client", ["--query=#{query}"]) do
      {data, 0} ->
        data

      otherwise ->
        raise RuntimeError,
          message: "Error running query #{inspect(query)}: #{inspect(otherwise)}"
    end
  end
end
