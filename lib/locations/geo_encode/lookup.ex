defmodule Locations.GeoEncode.Lookup do
  @moduledoc """
  Entry point to perform a lookup using the OpenStreetMap Nominatim service
  """

  require Logger

  alias Locations.External.HttpClient

  @url "https://nominatim.openstreetmap.org/search?"
  @format "&format=geojson&addressdetails=0"

  @doc """
  Geo encode the passed address.

  Returns the result of the address lookup. This will be a JSON decoded
  structure as returned from Nominatim or an error.


  """
  @spec geoencode(binary) :: {:error, any} | {:ok, number, any}
  def geoencode(address) do
    search_url = @url <> "q=" <> address <> @format

    referer = get_nominatim_referer()

    case HttpClient.get(search_url, [{"Referer", referer}], []) do
      {:error, reason} ->
        Logger.error("GeoEncode transport error #{inspect(reason)}")
        {:error, merge_errors(reason)}

      {:ok, response} ->
        process_response(response)
    end
  end

  defp process_response(%{status_code: status} = response) when status == 200 do
    case Jason.decode(response.body) do
      {:ok, body} ->
        {:ok, status, body}

      {:error, reason} ->
        Logger.error("GeoEncode json error #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp process_response(%{status_code: status}) do
    {:error, status}
  end

  defp merge_errors(%{message: nil, reason: reason}) when is_atom(reason) do
    reason
  end

  defp merge_errors(%{message: nil, reason: %{reason: reason}}) when is_atom(reason) do
    reason
  end

  defp merge_errors(%{message: msg, reason: nil}) do
    msg
  end

  defp merge_errors(%{message: msg, reason: %{reason: reason}}) when is_atom(reason) do
    "message: #{inspect(msg)} - reason: #{inspect(reason)}"
  end

  def get_nominatim_referer() do
    case Application.get_env(:locations, :nominatim_referer) do
      nil ->
        raise """
        You need to set the referer as required by the Nominatim service in your config file

        config :location, nominatim_referer: "<<My application>>"
        """

      other ->
        other
    end
  end
end
