defmodule ContentfulRenderer.Types do
  @blocks %{
    document: "document",
    paragraph: "paragraph",
    heading_1: "heading-1",
    heading_2: "heading-2",
    heading_3: "heading-3",
    heading_4: "heading-4",
    heading_5: "heading-5",
    heading_6: "heading-6",
    ol_list: "ordered-list",
    ul_list: "unordered-list",
    list_item: "list-item",
    hr: "hr",
    quote: "blockquote",
    embedded_entry: "embedded-entry-block",
    embedded_asset: "embedded-asset-block"
  }

  @marks %{
    bold: "bold",
    italic: "italic",
    underline: "underline",
    code: "code"
  }

  @inlines %{
    hyperlink: "hyperlink",
    entry_hyperlink: "entry-hyperlink",
    asset_hyperlink: "asset-hyperlink",
    embedded_entry: "embedded-entry-inline"
  }

  def blocks, do: @blocks
  def marks, do: @marks
  def inlines, do: @inlines
end
