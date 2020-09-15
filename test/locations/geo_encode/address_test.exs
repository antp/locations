defmodule Locations.GeoEncode.AddressTest do
  use ExUnit.Case

  import Locations.Factories

  alias Locations.GeoEncode.Address

  @test_fields [:addr1, :addr2, :city, :county, :postcode, :country]

  @tag :unit
  test "Will encode an address" do
    address = build(:location)

    parsed_address = Address.build_address(address)

    Enum.each(@test_fields, fn key ->
      expected = Map.get(address, key)
      expected = String.replace(expected, " ", "+")

      assert parsed_address =~ expected,
             "Expected: #{inspect(expected)}\nTo be in: #{inspect(parsed_address)}"
    end)
  end

  @tag :unit
  test "will not be present in the address" do
    Enum.each(@test_fields, fn key ->
      address =
        build(:location)
        |> Map.from_struct()

      should_be_missing = Map.get(address, key)

      address = Map.put(address, key, nil)

      parsed_address = Address.build_address(address)

      refute parsed_address =~ should_be_missing
    end)
  end
end
