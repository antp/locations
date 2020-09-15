defmodule Locations.AssertHelpers do
  import ExUnit.Assertions

  alias Ecto.Changeset

  def assert_valid_changeset(keys, expected_params, %Changeset{} = changeset) do
    assert %Changeset{valid?: true, changes: changes} = changeset

    Enum.each(keys, fn key ->
      expected = Map.get(expected_params, Atom.to_string(key))
      actual = Map.get(changes, key)

      assert expected == actual,
             "Error on: #{inspect(key)}\nExpected: #{inspect(expected)}\nExpected: #{
               inspect(actual)
             }"
    end)
  end

  def assert_invalid_cast_changeset(keys, %Changeset{} = changeset) do
    assert %Changeset{valid?: false, errors: errors} = changeset

    Enum.each(keys, fn key ->
      assert errors[key], "expected an error for #{key}"

      {_, meta} = errors[key]

      assert meta[:validation] == :cast,
             "The validation type, #{meta[:validation]}, is incorrect."
    end)
  end

  def assert_required_changeset(keys, %Changeset{} = changeset) do
    assert %Changeset{valid?: false, errors: errors} = changeset

    Enum.each(keys, fn key ->
      assert errors[key], "The required field #{inspect(key)} is missing from errors."

      {_, meta} = errors[key]

      assert meta[:validation] == :required,
             "The validation type, #{meta[:validation]}, is incorrect."
    end)
  end

  def assert_changeset_types(expected_keys_and_types, schema_name) do
    keys = schema_name.__schema__(:fields)

    actual_keys_and_types =
      Enum.map(keys, fn key ->
        key_type = schema_name.__schema__(:type, key)

        {key, key_type}
      end)

    actual_keys_and_types = Enum.sort(actual_keys_and_types)

    expected_keys_and_types = Enum.sort(expected_keys_and_types)

    if length(expected_keys_and_types) != length(actual_keys_and_types) do
      assert expected_keys_and_types == actual_keys_and_types
    end

    Enum.each(expected_keys_and_types, fn {key, expected_type} ->
      actual_type = Keyword.get(actual_keys_and_types, key)

      assert expected_type == actual_type,
             "Error on: #{inspect(key)}\nExpected #{inspect(expected_type)}\nActual: #{
               inspect(actual_type)
             }"
    end)
  end

  def assert_values_set_on_schema(expected_params, db_schema) do
    Enum.each(expected_params, fn {key, expected} ->
      db_key = String.to_existing_atom(key)
      actual = Map.get(db_schema, db_key)

      assert expected == actual,
             "Error on: #{inspect(key)}\nExpected: #{inspect(expected)}\nExpected: #{
               inspect(actual)
             }"
    end)
  end

  def assert_insert_timestamps(db_schema) do
    assert db_schema.inserted_at == db_schema.updated_at
  end

  def assert_update_timestamps(db_schema) do
    :lt == NaiveDateTime.compare(db_schema.inserted_at, db_schema.updated_at)
  end
end
