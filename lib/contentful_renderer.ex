defmodule ContentfulRenderer do
  @moduledoc """
  TODO
  """

  def to_html(doc = %{"content" => _}, opts \\ %{}) do
    ContentfulRenderer.Html.document_to_html_string(doc, opts)
  end
end
