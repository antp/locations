defmodule Locations.AssertLiveviewHelpers do
  import ExUnit.Assertions

  import Phoenix.LiveViewTest

  def assert_id_is_on_the_page(view, id) do
    assert has_element?(view, id),
           "Expected #{id} to be visible on the page"
  end

  def refute_id_is_on_the_page(view, id) do
    refute has_element?(view, id),
           "Expected #{id} to be visible on the page"
  end

  def assert_text_in_page(html, %{} = params) do
    Enum.each(params, fn {_key, expected} ->
      assert html =~ expected
    end)
  end

  def get_schema_count_in_db(schema_name) do
    Locations.Repo.all(schema_name)
    |> Enum.count()
  end

  def assert_form_errors(view, form_name, params) do
    Enum.each(params, fn {key, _value} ->
      error_id = build_error_id(form_name, key)

      assert_id_is_on_the_page(view, error_id)
    end)
  end

  def build_error_id(form_name, field) do
    "##{form_name}-#{field}-error"
  end
end
