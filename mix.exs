defmodule VibesGetter.MixProject do
  use Mix.Project

  def project do
    [
      app: :vibes_getter,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:reddit, "~>0.1.0"},
      {:httpoison, "~> 1.8"}
    ]
  end
end
