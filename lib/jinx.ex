defmodule Jinx do

  @moduledoc """
  Defines flexible test helpers for creating and testing
  JSON data [JSON APIs] (http://jsonapi.org)
  """

  def json_for(type, attributes) do
    attributes = normalize_json_attributes(attributes)

    %{
      "data" => %{
        "type" =>  Atom.to_string(type) |> String.replace("_", "-"),
        "attributes" => attributes,
      },
      "format" => "json-api"
    }
  end

  def json_for(type, attributes, %{} = relationships) do
    json = json_for(type, attributes)
    put_in json["data"]["relationships"], relationships
  end

  def json_for(type, attributes, id) do
    json = json_for(type, attributes)
    put_in json["data"]["id"], id
  end

  defp normalize_json_attributes(attributes) do
    attributes = attributes
      |> Map.delete(:__meta__)
      |> Map.delete(:__struct__)

    Enum.reduce attributes, %{}, fn({key, value}, result) ->
      case normalize_json_attribute(key, value) do
        {key, value} -> Map.put(result, key, value)
        nil -> result
      end
    end
  end

  defp normalize_json_attribute(key, value), do: {key, value}
end
