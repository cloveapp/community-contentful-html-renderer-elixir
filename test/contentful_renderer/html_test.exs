defmodule ContentfulRenderer.HtmlTest do
  use ExUnit.Case, async: true

  alias ContentfulRenderer.{Html, Types}
  alias Test.Fixtures

  test "returns empty string when given an empty document" do
    assert Html.document_to_html_string(Fixtures.empty()) == ""
  end

  test "renders nodes with default node renderer" do
    docs = [
      %{
        doc: Fixtures.paragraph(),
        expected: "<p>hello world</p>"
      },
      %{
        doc: Fixtures.heading_doc(Types.blocks().heading_1),
        expected: "<h1>hello world</h1>"
      },
      %{
        doc: Fixtures.heading_doc(Types.blocks().heading_2),
        expected: "<h2>hello world</h2>"
      },
      %{
        doc: Fixtures.heading_doc(Types.blocks().heading_3),
        expected: "<h3>hello world</h3>"
      },
      %{
        doc: Fixtures.heading_doc(Types.blocks().heading_4),
        expected: "<h4>hello world</h4>"
      },
      %{
        doc: Fixtures.heading_doc(Types.blocks().heading_5),
        expected: "<h5>hello world</h5>"
      },
      %{
        doc: Fixtures.heading_doc(Types.blocks().heading_6),
        expected: "<h6>hello world</h6>"
      }
    ]

    Enum.each(docs, fn %{doc: doc, expected: expected} ->
      assert Html.document_to_html_string(doc) == expected
    end)
  end

  test "renders marks with default mark renderer" do
    docs = [
      %{
        doc: Fixtures.mark_doc(Types.marks().italic),
        expected: "<p><i>hello world</i></p>"
      },
      %{
        doc: Fixtures.mark_doc(Types.marks().bold),
        expected: "<p><b>hello world</b></p>"
      },
      %{
        doc: Fixtures.mark_doc(Types.marks().underline),
        expected: "<p><u>hello world</u></p>"
      },
      %{
        doc: Fixtures.mark_doc(Types.marks().code),
        expected: "<p><code>hello world</code></p>"
      }
    ]

    Enum.each(docs, fn %{doc: doc, expected: expected} ->
      assert Html.document_to_html_string(doc) == expected
    end)
  end

  test "renders nodes with passed custom node renderer" do
    opts = %{
      render_node: %{
        Types.blocks().paragraph => fn node, next, _opts = %{} ->
          "<custom>#{next.(node["content"])}</custom>"
        end
      }
    }

    assert Html.document_to_html_string(Fixtures.paragraph(), opts) ==
             "<custom>hello world</custom>"
  end

  test "passes opts through to the custom node renderer" do
    opts = %{
      render_node: %{
        Types.blocks().paragraph => fn _, _, opts = %{} ->
          "<custom>#{opts.testing}</custom>"
        end
      },
      testing: "came from opts"
    }

    assert Html.document_to_html_string(Fixtures.paragraph(), opts) ==
             "<custom>came from opts</custom>"
  end

  test "renders marks with passed custom mark renderer" do
    opts = %{
      render_mark: %{
        Types.marks().italic => fn text, _opts = %{} -> "<custom>#{text}</custom>" end
      }
    }

    doc = Fixtures.mark_doc(Types.marks().italic)
    assert Html.document_to_html_string(doc, opts) == "<p><custom>hello world</custom></p>"
  end

  test "passes opts through to the marks renderer" do
    opts = %{
      render_mark: %{
        Types.marks().italic => fn text, opts = %{} -> "<#{opts.test}>#{text}</#{opts.test}>" end
      },
      test: "an-opt"
    }

    doc = Fixtures.mark_doc(Types.marks().italic)
    assert Html.document_to_html_string(doc, opts) == "<p><an-opt>hello world</an-opt></p>"
  end

  test "renders escaped html" do
    assert Html.document_to_html_string(Fixtures.with_entities()) == "<p>foo &amp; bar</p>"
  end

  test "renders escaped html with marks" do
    assert Html.document_to_html_string(Fixtures.entities_with_marks()) ==
             "<p><b><u>foo &amp; bar</u></b></p>"
  end

  test "does not render unrecognized marks" do
    assert Html.document_to_html_string(Fixtures.mark_doc("nope")) == "<p>hello world</p>"
  end

  test "renders empty node if type is not recognized" do
    assert Html.document_to_html_string(Fixtures.heading_doc("nope")) == ""

    assert Html.document_to_html_string(Fixtures.nested_doc(Fixtures.heading_doc("nope"))) ==
             "<p>subdoc</p>"
  end

  test "renders default entry link block" do
    entry = %{
      "sys" => %{
        "id" => "9mpxT4zsRi6Iwukey8KeM",
        "link" => "Link",
        "linkType" => "Entry"
      }
    }

    assert Html.document_to_html_string(Fixtures.embedded_entry(entry)) == "<div></div>"
  end

  test "renders ordered lists" do
    expected = "<ol><li><p>Hello</p></li><li><p>world</p></li></ol><p></p>"
    assert Html.document_to_html_string(Fixtures.ol_doc()) == expected
  end

  test "renders unordered lists" do
    expected = "<ul><li><p>Hello</p></li><li><p>world</p></li></ul><p></p>"
    assert Html.document_to_html_string(Fixtures.ul_doc()) == expected
  end

  test "renders blockquotes" do
    expected = "<p>hello</p><blockquote>world</blockquote>"
    assert Html.document_to_html_string(Fixtures.quote_doc()) == expected
  end

  test "renders horizontal rules" do
    expected = "<p>hello world</p><hr/><p></p>"
    assert Html.document_to_html_string(Fixtures.hr_doc()) == expected
  end

  test "renders hyperlink" do
    expected = "<p>Some text <a href=\"https://url.org\">link</a> text.</p>"
    assert Html.document_to_html_string(Fixtures.hyperlink_doc()) == expected
  end

  test "renders asset hyperlink" do
    asset = %{
      "target" => %{
        "sys" => %{
          "id" => "9mpxT4zsRi6Iwukey8KeM",
          "link" => "Link",
          "type" => "Asset"
        }
      }
    }

    doc = Fixtures.inline_entity(asset, Types.inlines().asset_hyperlink)
    expected = "<p><span>type: asset-hyperlink id: 9mpxT4zsRi6Iwukey8KeM</span></p>"

    assert Html.document_to_html_string(doc) == expected
  end

  test "renders entry hyperlink" do
    asset = %{
      "target" => %{
        "sys" => %{
          "id" => "9mpxT4zsRi6Iwukey8KeM",
          "link" => "Link",
          "type" => "Asset"
        }
      }
    }

    doc = Fixtures.inline_entity(asset, Types.inlines().entry_hyperlink)
    expected = "<p><span>type: entry-hyperlink id: 9mpxT4zsRi6Iwukey8KeM</span></p>"

    assert Html.document_to_html_string(doc) == expected
  end

  test "renders embedded entry" do
    asset = %{
      "target" => %{
        "sys" => %{
          "id" => "9mpxT4zsRi6Iwukey8KeM",
          "link" => "Link",
          "type" => "Asset"
        }
      }
    }

    doc = Fixtures.inline_entity(asset, Types.inlines().embedded_entry)
    expected = "<p><span>type: embedded-entry-inline id: 9mpxT4zsRi6Iwukey8KeM</span></p>"

    assert Html.document_to_html_string(doc) == expected
  end
end
