defmodule ExUnitAssertions.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_unit_assertions,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:ex_unit]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    "useful ExUnit assertions"
  end

  defp package do
    [maintainers: ["Yuri Artemev"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/artemeff/ex_unit_assertions"}]
  end
end
