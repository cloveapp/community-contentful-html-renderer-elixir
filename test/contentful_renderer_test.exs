defmodule ContentfulRendererTest do
  use ExUnit.Case, async: true

  test "doc_to_html is exported" do
    assert ContentfulRenderer.doc_to_html(Test.Fixtures.paragraph()) == "<p>hello world</p>"
    assert ContentfulRenderer.doc_to_html(Test.Fixtures.paragraph(), %{}) == "<p>hello world</p>"
    assert ContentfulRenderer.doc_to_html(Test.Fixtures.paragraph(), %{
      render_node: %{
        ContentfulRenderer.Types.blocks().paragraph => fn node, next, _ ->
          "<div>#{next.(node["content"])}</div>"
        end
      }
    }) == "<div>hello world</div>"
  end

  test "content_to_html is exported" do
    %{"content" => content} = Test.Fixtures.paragraph()
    assert ContentfulRenderer.content_to_html(content) == "<p>hello world</p>"
  end
end
