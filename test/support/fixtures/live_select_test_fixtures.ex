defmodule Locality.LiveSelectTestFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Locality.LiveSelectTest` context.
  """

  @doc """
  Generate a mock_location.
  """
  def mock_location_fixture(attrs \\ %{}) do
    {:ok, mock_location} =
      attrs
      |> Enum.into(%{
        city_id: "some city_id",
        note: "some note"
      })
      |> Locality.LiveSelectTest.create_mock_location()

    mock_location
  end
end
