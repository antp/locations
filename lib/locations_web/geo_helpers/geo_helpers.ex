defmodule LocationsWeb.GeoHelpers do
  @moduledoc """
  GEO helpers
  """

  @doc """
  Returns the type of the features for a location
  """
  def get_feature_type(%{geo_features: features}) when length(features) > 1 do
    :multiple_features
  end

  def get_feature_type(%{geo_features: features}) when length(features) == 1 do
    :single_feature
  end

  def get_feature_type(_) do
    :no_features
  end

  @doc """
  Returns the first features entry from a collection of features
  """
  def get_first_encoding_result(features) do
    geo_selected_id = get_first_geo__id(features)

    get_location_for_selected(features, geo_selected_id)
  end

  @doc """
  Returns the display name of a place
  """
  def get_geo_place_display_name(geo_place) do
    if name = geo_place["properties"]["display_name"] do
      name
    else
      get_geo_place_id(geo_place)
    end
  end

  @doc """
  Returns the type of a place
  """
  def get_geo_place_display_type(geo_place) do
    if type = geo_place["properties"]["type"] do
      type
    else
      "unknown"
    end
  end

  @doc """
  Returns the osm_id for a place
  """
  def get_geo_place_id(geo_place) do
    geo_place["properties"]["osm_id"]
  end

  @doc """
  Returns the feature from the collection of features for the passed osm_id
  """
  def get_location_for_selected(features, geo_id) do
    with {:ok, geometry} <- get_geometry(features, geo_id),
         {:ok, geometry} <- has_geometry(geometry),
         {:ok, coordinates} <- get_coordinates(geometry) do
      geo_location = create_geo_location(coordinates)
      {:ok, geo_location, geo_id}
    else
      reason ->
        reason
    end
  end

  defp create_geo_location([lon, lat]) do
    %{
      lat: lat,
      lon: lon
    }
  end

  defp get_coordinates(geometry) do
    if Map.has_key?(geometry, "coordinates") do
      {:ok, geometry["coordinates"]}
    else
      {:error, :no_coordinates}
    end
  end

  defp has_geometry(nil) do
    {:error, :no_geometry_nil}
  end

  defp has_geometry([]) do
    {:error, :no_geometry_empty}
  end

  defp has_geometry(geometry) do
    {:ok, geometry}
  end

  defp get_geometry([], _geo_id) do
    {:error, :no_features}
  end

  defp get_geometry(features, _geo_id) when 1 == length(features) do
    feature = hd(features)

    get_geometry_from_feature(feature)
  end

  defp get_geometry(features, geo_id) do
    feature =
      Enum.find(features, fn place ->
        geo_id == get_geo_place_id(place)
      end)

    get_geometry_from_feature(feature)
  end

  defp get_geometry_from_feature(nil) do
    {:error, :no_feature}
  end

  defp get_geometry_from_feature(feature) do
    if Map.has_key?(feature, "geometry") do
      {:ok, feature["geometry"]}
    else
      {:error, :no_geometry}
    end
  end

  defp get_first_geo__id([]) do
    nil
  end

  defp get_first_geo__id(geo_features) do
    place = hd(geo_features)

    get_geo_place_id(place)
  end
end
