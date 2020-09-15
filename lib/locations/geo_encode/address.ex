defmodule Locations.GeoEncode.Address do
  @moduledoc """
  Build an address query string for the OpenStreetMap nominatim service

  This will encode the following string values in the passed map:

    addr1
    addr2
    city
    county
    postcode
    country

  All values are optional.

  """
  def build_address(entry) do
    ""
    |> addr1(entry)
    |> addr2(entry)
    |> city(entry)
    |> county(entry)
    |> postcode(entry)
    |> country(entry)
    |> ensure_no_spaces()
  end

  defp ensure_no_spaces(address) do
    String.replace(address, " ", "+")
  end

  defp addr1(address, %{addr1: nil}) do
    address
  end

  defp addr1(_address, %{addr1: value}) do
    String.trim(value)
  end

  defp addr2(address, %{addr2: nil}) do
    address
  end

  defp addr2(address, %{addr2: value}) do
    address <> "%2C" <> "+" <> String.trim(value)
  end

  defp city(address, %{city: nil}) do
    address
  end

  defp city(address, %{city: value}) do
    address <> "%2C" <> "+" <> String.trim(value)
  end

  defp county(address, %{county: nil}) do
    address
  end

  defp county(address, %{county: value}) do
    address <> "%2C" <> "+" <> String.trim(value)
  end

  defp postcode(address, %{postcode: nil}) do
    address
  end

  defp postcode(address, %{postcode: value}) do
    address <> "%2C" <> "+" <> String.trim(value)
  end

  defp country(address, %{country: nil}) do
    address
  end

  defp country(address, %{country: value}) do
    address <> "%2C" <> "+" <> String.trim(value)
  end
end
