defmodule Locations.Repo.Migrations.AddLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(:addr1, :string, null: false)
      add(:addr2, :string, null: true)
      add(:city, :string, null: false)
      add(:county, :string, null: true)
      add(:postcode, :string, null: false)
      add(:country, :string, null: false)

      add(:geo_error, :binary, null: true)
      add(:geo_selected_id, :int8, null: true)
      add(:geo_features, :jsonb, null: true)
      add(:lat, :float, null: true)
      add(:lon, :float, null: true)
      add(:geolocation, :geometry, null: true)

      timestamps()
    end
  end
end
