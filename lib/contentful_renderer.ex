defmodule ContentfulRenderer do
  @moduledoc """
  TODO
  """

  def doc_to_html(doc, opts \\ %{}) when is_map(doc) or is_list(doc) do
    ContentfulRenderer.Html.document_to_html_string(doc, opts)
  end

  def content_to_html(doc, opts \\ %{}) when is_map(doc) or is_list(doc) do
    ContentfulRenderer.Html.content_to_html_string(doc, opts)
  end
end
