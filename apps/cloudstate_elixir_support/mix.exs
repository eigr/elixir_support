defmodule CloudstateElixirSupport.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloudstate_elixir_support,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11-dev",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
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
      # Base deps
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:flow, "~> 1.0"},
      {:google_protos, "~> 0.1.0"},

      # Grpc deps
      {:grpc, github: "elixir-grpc/grpc"},
      # 2.9.0 fixes some important bugs, so it's better to use ~> 2.9.0
      {:cowlib, "~> 2.9.0", override: true}
    ]
  end

  defp description do
    """
    CloudState Elixir Support offers an idiomatic support library for writing stateful services.
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :cloudstate,
     organization: "Mungotinae",
     files: ["lib", "mix.exs", "README*"],
     maintainers: ["Adriano Santos", "Marcel Lanz"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/mungotinae/elixir_support"}]
  end
end
