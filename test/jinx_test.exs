defmodule JinxTest do
  use ExUnit.Case
  import Jinx, only: [json_for: 2, json_for: 3]

  describe "json_for" do
    test "it properly adds fields to attributes" do
      attrs = %{foo: "bar", food: "candy bar"}
      json_payload = json_for(:foo, attrs)

      expected = %{
        "data" => %{"attributes" => attrs, "type" => "foo"},
        "format" => "json-api"
      }

      assert json_payload == expected
    end

    test "it properly adds relationships to data" do
      attrs = %{name: "Scott", isTheBest: true}
      relationships = %{"job" => %{"data" => %{type: "job", id: 1}}}

      json_payload = json_for(:person, attrs, relationships)

      expected = %{
        "data" => %{
          "attributes" => attrs,
          "type" => "person",
          "relationships" => relationships
        },
        "format" => "json-api"
      }

      assert json_payload == expected
    end

    test "it replaces_snake case with kebab-case for json type" do
      json_payload = json_for(:some_super_cool_model, %{})

      assert Map.get(json_payload["data"], "type") == "some-super-cool-model"
    end

    test "it removes __meta__ and __struct__ attrs" do
      attrs = %{:foo => "bar", :__meta__ => "stuff", :__struct__ => "moar stuff"}
      data =  json_for(:foo, attrs) |> Map.get("data")

      assert Map.get(data, "attributes") == %{:foo => "bar"}
    end
  end
end
