defmodule Locations.GeoEncode.LookupTest do
  use ExUnit.Case

  import Mox

  alias Locations.Support.NominatimData

  alias Locations.GeoEncode.Lookup

  @moduletag capture_log: true

  @tag :unit
  test "will return a good response" do
    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_good_response()}
      end
    )

    address = "address"

    {:ok, _status, rersponse} = Lookup.geoencode(address)

    features = rersponse["features"]
    feature = hd(features)
    [lon, lat] = feature["geometry"]["coordinates"]

    Mox.verify!(MockHttp)
    assert 51.7904389 == lat
    assert -0.894139715767561 == lon
  end

  @tag :unit
  test "will return an error when the transport errors :nxdomain" do
    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:error, NominatimData.get_transport_error(nil, :nxdomain)}
      end
    )

    address = "address"

    {:error, reason} = Lookup.geoencode(address)

    Mox.verify!(MockHttp)
    assert :nxdomain == reason
  end

  @tag :unit
  test "will return an error when the transport errors bad url" do
    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:error, NominatimData.get_transport_error("invalid URL: test", nil)}
      end
    )

    address = "address"

    {:error, reason} = Lookup.geoencode(address)

    Mox.verify!(MockHttp)
    assert "invalid URL: test" == reason
  end

  @tag :unit
  test "will return data when the address is not encoded (no features)" do
    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_status_response(200)}
      end
    )

    address = "address"

    {:ok, status, response} = Lookup.geoencode(address)

    Mox.verify!(MockHttp)
    assert 200 == status
    assert "" != response
  end

  @tag :unit
  test "will return no data on a bad encoding" do
    expect(
      MockHttp,
      :get,
      fn _url, _headers, _opts ->
        {:ok, NominatimData.get_nominatim_status_response(201)}
      end
    )

    address = "address"

    {:error, 201} = Lookup.geoencode(address)

    Mox.verify!(MockHttp)
  end
end
