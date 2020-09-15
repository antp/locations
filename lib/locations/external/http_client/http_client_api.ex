defmodule Locations.External.HttpClientApi do
  @moduledoc """
  Behaviour to support calling the Mojito http library.

  Using this behaviour allows the use of Mox to inject return
  types when testing.
  """

  @callback get(String.t(), Mojito.headers(), Keyword.t()) ::
              {:ok, Mojito.response()} | {:error, Mojito.error()} | no_return
end
