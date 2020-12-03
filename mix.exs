defmodule ContentfulRenderer.MixProject do
  use Mix.Project

  def project do
    [
      app: :community_contentful_html_renderer,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "RichText to HTML Renderer for Contentful",
      package: %{
        licenses: ["MIT AND Apache-2.0"],
        links: %{
          github: "https://github.com/cloveapp/community-contentful-html-renderer-elixir"
        }
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0", only: :test}
    ]
  end
end
