defmodule JinxTest do
  use ExUnit.Case
  import Jinx, only: [json_for: 2, json_for: 3]

  describe "json_for/2" do
    test "it properly adds fields to attributes" do
      attrs = %{foo: "bar", food: "candy bar"}
      json_payload = json_for(:person, attrs)

      expected = %{
        "data" => %{
          "attributes" => attrs,
          "type" => "person"
        },
        "format" => "json-api"
      }

      assert json_payload == expected
    end

    test "it replaces_snake case with kebab-case for json type" do
      data = json_for(:some_super_cool_model, %{}) |> Map.get("data")

      assert Map.get(data, "type") == "some-super-cool-model"
    end

    test "it removes __meta__ and __struct__ attrs" do
      attrs = %{:foo => "bar", :__meta__ => "stuff", :__struct__ => "moar stuff"}
      data =  json_for(:foo, attrs) |> Map.get("data")

      assert Map.get(data, "attributes") == %{:foo => "bar"}
    end
  end

  describe "json_for/3" do
    test "it properly adds relationships to data" do
      attrs = %{name: "Scott", is_the_best: true}
      relationships = %{
        "job" => %{
          "data" => %{
            type: "job", id: 1
          }
        }
      }

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
  end
end
