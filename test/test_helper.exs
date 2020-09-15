Mox.defmock(MockHttp, for: Locations.External.HttpClientApi)
Application.put_env(:locations, :http_impl, MockHttp)

Faker.start()
ExUnit.start(exclude: [:pending, :external])
Ecto.Adapters.SQL.Sandbox.mode(Locations.Repo, :manual)
