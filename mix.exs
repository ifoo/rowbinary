defmodule RowBinary.MixProject do
  use Mix.Project

  def project do
    [
      app: :rowbinary,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "RowBinary",
      source_url: "https://github.com/ifoo/rowbinary",
      docs: [
        main: "RowBinary",
        extras: ["README.md"]
      ]
    ]
  end

  defp description do
    """
    Library for working with RowBinary format in ClickHouse.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Philip Pum"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ifoo/rowbinary"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end
end
