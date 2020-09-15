defmodule Locations.GeoEncode.Nominatim do
  @moduledoc """
  Extract the GEO features from a Nominatim result
  """

  @doc """
  Extract the GEO features from a Nominatim result
  """

  @spec get_location(<<>> | map) :: {:error, :no_data | :no_features | :no_location} | {:ok, any}
  def get_location("") do
    {:error, :no_data}
  end

  def get_location(data) do
    with {:ok, features} <- get_features(data),
         {:ok, features} <- has_features(features) do
      {:ok, features}
    else
      reason ->
        reason
    end
  end

  defp has_features([]) do
    {:error, :no_features}
  end

  defp has_features(features) do
    {:ok, features}
  end

  defp get_features(data) do
    if Map.has_key?(data, "features") do
      {:ok, data["features"]}
    else
      {:error, :no_location}
    end
  end
end
