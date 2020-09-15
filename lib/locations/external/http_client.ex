defmodule Locations.External.HttpClient do
  @moduledoc """
  Perform a GET request to an external URL.

  During tests this will call a mock via the MOX library.

  The def_get_impl macro will in development and test mode perform
  an Application.get_env to obtain the module to call.

  In production this is replaced with a function call return the module.
  """

  @behaviour Locations.External.HttpClientApi

  import Locations.Helpers.DefGetImpl

  def_get_impl(:http_impl, impl: Locations.External.HttpClientImpl)

  @doc """
  Perform a GET request to an external URL.

  Returns the response from the external URL
  """
  def get(url, headers, opts) do
    http_impl().get(url, headers, opts)
  end
end
