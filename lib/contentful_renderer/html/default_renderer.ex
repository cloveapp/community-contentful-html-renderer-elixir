defmodule ContentfulRenderer.Html.DefaultRenderer do
  alias ContentfulRenderer.Types

  def paragraph(node, next, _opts) do
    "<p>#{next.(node["content"])}</p>"
  end

  def heading_1(node, next, _opts) do
    "<h1>#{next.(node["content"])}</h1>"
  end

  def heading_2(node, next, _opts) do
    "<h2>#{next.(node["content"])}</h2>"
  end

  def heading_3(node, next, _opts) do
    "<h3>#{next.(node["content"])}</h3>"
  end

  def heading_4(node, next, _opts) do
    "<h4>#{next.(node["content"])}</h4>"
  end

  def heading_5(node, next, _opts) do
    "<h5>#{next.(node["content"])}</h5>"
  end

  def heading_6(node, next, _opts) do
    "<h6>#{next.(node["content"])}</h6>"
  end

  def embedded_entry(node, next, _opts) do
    "<div>#{next.(node["content"])}</div>"
  end

  def ul_list(node, next, _opts) do
    "<ul>#{next.(node["content"])}</ul>"
  end

  def ol_list(node, next, _opts) do
    "<ol>#{next.(node["content"])}</ol>"
  end

  def list_item(node, next, _opts) do
    "<li>#{next.(node["content"])}</li>"
  end

  def hr(_, _, _opts) do
    "<hr/>"
  end

  def quote(node, next, _opts) do
    "<blockquote>#{next.(node["content"])}</blockquote>"
  end

  def asset_hyperlink(node, _, _opts) do
    default_inline(Types.inlines().asset_hyperlink, node)
  end

  def entry_hyperlink(node, _, _opts) do
    default_inline(Types.inlines().entry_hyperlink, node)
  end

  def embedded_entry_inline(node, _, _opts) do
    default_inline(Types.inlines().embedded_entry, node)
  end

  def hyperlink(node, next, _opts) do
    "<a href=\"#{node["data"]["uri"]}\">#{next.(node["content"])}</a>"
  end

  def mark_italic(value, _opts) do
    "<i>#{value}</i>"
  end

  def mark_bold(value, _opts) do
    "<b>#{value}</b>"
  end

  def mark_underline(value, _opts) do
    "<u>#{value}</u>"
  end

  def mark_code(value, _opts) do
    "<code>#{value}</code>"
  end

  defp default_inline(type, node) do
    "<span>type: #{type} id: #{node["data"]["target"]["sys"]["id"]}</span>"
  end
end
