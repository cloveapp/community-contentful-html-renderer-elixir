defmodule Test.Fixtures do
  import ContentfulRenderer.Types

  def empty do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => []
    }
  end

  def paragraph, do: mock("paragraph.json")

  def ol_doc, do: mock("ol_doc.json")

  def ul_doc, do: mock("ul_doc.json")

  def quote_doc, do: mock("quote_doc.json")

  def hr_doc, do: mock("hr_doc.json")

  def hyperlink_doc, do: mock("hyperlink_doc.json")

  def heading_doc(heading) do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => [
        %{
          "nodeType" => heading,
          "data" => %{},
          "content" => [
            %{
              "nodeType" => "text",
              "value" => "hello world",
              "marks" => [],
              "data" => %{}
            }
          ]
        }
      ]
    }
  end

  def mark_doc(mark) do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => [
        %{
          "nodeType" => blocks().paragraph,
          "data" => %{},
          "content" => [
            %{
              "nodeType" => "text",
              "value" => "hello world",
              "marks" => [%{"type" => mark}],
              "data" => %{}
            }
          ]
        }
      ]
    }
  end

  def nested_doc(subdoc) do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => [
        %{
          "nodeType" => blocks().paragraph,
          "data" => {},
          "content" => [
            %{
              "nodeType" => "text",
              "value" => "subdoc",
              "marks" => [],
              "data" => %{}
            },
            subdoc
          ]
        }
      ]
    }
  end

  def with_entities do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => [
        %{
          "nodeType" => blocks().paragraph,
          "data" => {},
          "content" => [
            %{
              "nodeType" => "text",
              "value" => "foo & bar",
              "marks" => [],
              "data" => %{}
            }
          ]
        }
      ]
    }
  end

  def entities_with_marks do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => [
        %{
          "nodeType" => blocks().paragraph,
          "data" => %{},
          "content" => [
            %{
              "nodeType" => "text",
              "value" => "foo & bar",
              "marks" => [%{"type" => marks().underline}, %{"type" => marks().bold}],
              "data" => %{}
            }
          ]
        }
      ]
    }
  end

  def embedded_entry(entry) do
    %{
      "nodeType" => blocks().document,
      "data" => %{},
      "content" => [
        %{
          "nodeType" => blocks().embedded_entry,
          "content" => [],
          "data" => %{
            "target" => entry
          }
        }
      ]
    }
  end

  def inline_entity(entry, inline_type) do
    %{
      "content" => [
        %{
          "data" => %{},
          "content" => [
            %{
              "marks" => [],
              "value" => "",
              "nodeType" => "text",
              "data" => %{}
            },
            %{
              "data" => entry,
              "content" => [
                %{
                  "marks" => [],
                  "value" => "",
                  "nodeType" => "text",
                  "data" => %{}
                }
              ],
              "nodeType" => inline_type
            },
            %{
              "marks" => [],
              "value" => "",
              "nodeType" => "text",
              "data" => %{}
            }
          ],
          "nodeType" => blocks().paragraph
        }
      ],
      "data" => %{},
      "nodeType" => blocks().document
    }
  end

  defp mock(file) do
    ("test/support/fixtures/" <> file)
    |> File.read!()
    |> Jason.decode!()
  end
end
