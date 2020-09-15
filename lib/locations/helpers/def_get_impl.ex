defmodule Locations.Helpers.DefGetImpl do
  @moduledoc """
  This module defines a helper function to return the implementation
  module for a function.

  If test mode the implementation is found via

    Application.get_env(application, env, default)

  and in dev and prod modes the default implementation is returned.


  ## Example

    defmodule SomeModule do
      use Locations.Helpers.DefGetImpl

      def_get_impl(:register_impl, impl: RegisterImpl)

      def register(data) do
        register_impl().register(data)
      end
    end
  """
  defmacro def_get_impl(func, opts) do
    name = get_env(opts, :impl)
    impl_name = get_env(opts, :impl)

    quote location: :keep do
      source_line = __ENV__.line

      env = Mix.env()
      validate_options(unquote(opts), source_line)

      if :test == env do
        def unquote(func)() do
          {:ok, app} = :application.get_application(__MODULE__)
          env_name = unquote(func)
          Application.get_env(app, env_name, unquote(impl_name))
        end
      else
        def unquote(func)() do
          unquote(name)
        end
      end
    end
  end

  @doc false
  def validate_options(opts, source_line) do
    if nil == Keyword.get(opts, :impl, nil) do
      raise """
      Missing impl: for def_get_impl on line #{source_line}
      """
    end
  end

  def get_env(opts, env) do
    Keyword.get(opts, env, nil)
  end
end
