defmodule Locality.LiveSelectTest do
  @moduledoc """
  The LiveSelectTest context.
  """

  import Ecto.Query, warn: false
  alias Locality.Repo

  alias Locality.LiveSelectTest.MockLocation
  alias Locality.Locations.City

  @doc """
  Returns the list of mock_locations.

  ## Examples

      iex> list_mock_locations()
      [%MockLocation{}, ...]

  """
  def list_mock_locations do
    Repo.all(MockLocation)
  end

  @doc """
  Returns the list of mock_locations, with the `City` association.

  ## Examples

      iex> list_mock_locations_with_city()
      [%MockLocation{}, ...]

  """
  def list_mock_locations_with_city() do
    query =
      from(
        m in MockLocation,
        left_join: c in City,
        on: m.city_id == c.id,
        select: %{
          id: m.id,
          note: m.note |> coalesce(""),
          city_id: m.city_id,
          city_name: c.name
        }
      )

    Repo.all(query)
  end

  @doc """
  Gets a single mock_location.

  Raises `Ecto.NoResultsError` if the Mock location does not exist.

  ## Examples

      iex> get_mock_location!(123)
      %MockLocation{}

      iex> get_mock_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mock_location!(id), do: Repo.get!(MockLocation, id)

  @doc """
  Gets a single mock_location, with its `City` association.

  Raises `Ecto.NoResultsError` if the Mock location does not exist.

  ## Examples

      iex> get_mock_location_with_city!(123)
      %MockLocation{}

      iex> get_mock_location_with_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mock_location_with_city!(id) do
    query =
      from(
        m in MockLocation,
        left_join: c in City,
        on: m.city_id == c.id,
        where: m.id == ^id,
        select: %{
          id: m.id,
          note: m.note |> coalesce(""),
          city_id: m.city_id,
          city_name: c.name
        }
      )
    Repo.one(query)
  end

  @doc """
  Creates a mock_location.

  ## Examples

      iex> create_mock_location(%{field: value})
      {:ok, %MockLocation{}}

      iex> create_mock_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mock_location(attrs \\ %{}) do
    %MockLocation{}
    |> MockLocation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mock_location.

  ## Examples

      iex> update_mock_location(mock_location, %{field: new_value})
      {:ok, %MockLocation{}}

      iex> update_mock_location(mock_location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mock_location(%MockLocation{} = mock_location, attrs) do
    mock_location
    |> MockLocation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mock_location.

  ## Examples

      iex> delete_mock_location(mock_location)
      {:ok, %MockLocation{}}

      iex> delete_mock_location(mock_location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mock_location(%MockLocation{} = mock_location) do
    Repo.delete(mock_location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mock_location changes.

  ## Examples

      iex> change_mock_location(mock_location)
      %Ecto.Changeset{data: %MockLocation{}}

  """
  def change_mock_location(%MockLocation{} = mock_location, attrs \\ %{}) do
    MockLocation.changeset(mock_location, attrs)
  end
end
