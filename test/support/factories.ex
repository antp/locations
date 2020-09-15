defmodule Locations.Factories do
  use ExMachina.Ecto, repo: Locations.Repo

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Locations.Repo

  alias Locations.Schema.Location

  def location_factory(attrs) do
    location = %Location{
      addr1: Faker.Address.street_address(),
      addr2: Faker.Address.street_name(),
      city: Faker.Address.city(),
      county: Faker.Address.state(),
      postcode: Faker.Address.postcode(),
      country: Faker.Address.country()
    }

    merge_attributes(location, attrs)
  end
end
