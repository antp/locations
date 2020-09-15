Postgrex.Types.define(
  Locations.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions()
  # json: :jason
)
