defmodule Locations.External.HttpClientImpl do
  @moduledoc """
  Perform a GET request to an external URL.
  """

  @doc """
  Perform a GET request to an external URL.

  Returns the response from the external URL
  """
  @spec get(binary, [{binary, binary}], keyword) ::
          {:error, Mojito.Error.t()} | {:ok, Mojito.Response.t()}

  def get(url, headers, opts) do
    Mojito.get(url, headers, opts)
  end
end
