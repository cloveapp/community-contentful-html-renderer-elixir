defmodule ContentfulRenderer.Html do
  import ContentfulRenderer.Types
  alias ContentfulRenderer.Html.DefaultRenderer

  def document_to_html_string(%{"content" => content}, opts \\ %{}) do
    content_to_html_string(content, opts)
  end

  def content_to_html_string(content, opts \\ %{}) when is_map(content) or is_list(content) do
    defaulted_opts =
      Map.merge(opts, %{
        render_node: Map.merge(default_renderers(), Map.get(opts, :render_node, %{})),
        render_mark: Map.merge(default_marks(), Map.get(opts, :render_mark, %{}))
      })

    node_to_string(content, defaulted_opts)
  end

  defp node_to_string(nodes, opts) when is_list(nodes) do
    nodes
    |> Enum.map(&node_to_string(&1, opts))
    |> Enum.join("")
  end

  defp node_to_string(node = %{"nodeType" => "text"}, opts) do
    node_value = ContentfulRenderer.HtmlEscape.html_escape(node["value"])
    add_marks_to_text(node_value, node["marks"], opts)
  end

  defp node_to_string(node = %{"nodeType" => type}, opts) do
    next_node = fn nodes ->
      node_to_string(nodes, opts)
    end

    case Map.get(opts.render_node, type) do
      nil ->
        ""

      render_fn ->
        render_fn.(node, next_node, opts)
    end
  end

  defp add_marks_to_text(text, [%{"type" => type} | rest], opts) do
    case Map.get(opts.render_mark, type) do
      nil ->
        add_marks_to_text(text, rest, opts)

      render_fn ->
        applied = render_fn.(text, opts)
        add_marks_to_text(applied, rest, opts)
    end
  end

  defp add_marks_to_text(text, _, _), do: text

  defp default_renderers,
    do: %{
      blocks().paragraph => &DefaultRenderer.paragraph/3,
      blocks().heading_1 => &DefaultRenderer.heading_1/3,
      blocks().heading_2 => &DefaultRenderer.heading_2/3,
      blocks().heading_3 => &DefaultRenderer.heading_3/3,
      blocks().heading_4 => &DefaultRenderer.heading_4/3,
      blocks().heading_5 => &DefaultRenderer.heading_5/3,
      blocks().heading_6 => &DefaultRenderer.heading_6/3,
      blocks().embedded_entry => &DefaultRenderer.embedded_entry/3,
      blocks().ul_list => &DefaultRenderer.ul_list/3,
      blocks().ol_list => &DefaultRenderer.ol_list/3,
      blocks().list_item => &DefaultRenderer.list_item/3,
      blocks().hr => &DefaultRenderer.hr/3,
      blocks().quote => &DefaultRenderer.quote/3,
      # inlines
      inlines().asset_hyperlink => &DefaultRenderer.asset_hyperlink/3,
      inlines().entry_hyperlink => &DefaultRenderer.entry_hyperlink/3,
      inlines().embedded_entry => &DefaultRenderer.embedded_entry_inline/3,
      inlines().hyperlink => &DefaultRenderer.hyperlink/3
    }

  defp default_marks,
    do: %{
      marks().italic => &DefaultRenderer.mark_italic/2,
      marks().bold => &DefaultRenderer.mark_bold/2,
      marks().underline => &DefaultRenderer.mark_underline/2,
      marks().code => &DefaultRenderer.mark_code/2
    }
end
