defmodule FBJunior.Mixfile do
  use Mix.Project

  def project do
    [app: :fbjunior,
     version: "0.1.0",
     elixir: "~> 1.9",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :cowboy, :plug, :jason, :redix],
      mod: {FBJunior, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.3.3"},
      {:cowboy, "~> 1.1.2"},
      {:jason, "~> 1.1"},
      {:redix, ">= 0.0.0"}
    ]
  end
end