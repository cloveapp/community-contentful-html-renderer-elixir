defmodule ContentfulRendererTest do
  use ExUnit.Case, async: true

  test "to_html is exported" do
    assert ContentfulRenderer.to_html(Test.Fixtures.paragraph()) == "<p>hello world</p>"
    assert ContentfulRenderer.to_html(Test.Fixtures.paragraph(), %{}) == "<p>hello world</p>"
    assert ContentfulRenderer.to_html(Test.Fixtures.paragraph(), %{
      render_node: %{
        ContentfulRenderer.Types.blocks().paragraph => fn node, next, _ ->
          "<div>#{next.(node["content"])}</div>"
        end
      }
    }) == "<div>hello world</div>"
  end
end
