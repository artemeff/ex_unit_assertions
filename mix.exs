defmodule ExUnitAssertions.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_unit_assertions,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:ex_unit]]
  end

  defp deps do
    []
  end
end
