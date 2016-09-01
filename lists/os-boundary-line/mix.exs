defmodule BoundaryLine.Mixfile do
  use Mix.Project

  def project do
    [app: :boundary_line,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:data_morph, "~> 0.0.3"},
    ]
  end
end
