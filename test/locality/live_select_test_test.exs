defmodule Locality.LiveSelectTestTest do
  use Locality.DataCase

  alias Locality.LiveSelectTest

  describe "mock_locations" do
    alias Locality.LiveSelectTest.MockLocation

    import Locality.LiveSelectTestFixtures

    @invalid_attrs %{city_id: nil, note: nil}

    test "list_mock_locations/0 returns all mock_locations" do
      mock_location = mock_location_fixture()
      assert LiveSelectTest.list_mock_locations() == [mock_location]
    end

    test "get_mock_location!/1 returns the mock_location with given id" do
      mock_location = mock_location_fixture()
      assert LiveSelectTest.get_mock_location!(mock_location.id) == mock_location
    end

    test "create_mock_location/1 with valid data creates a mock_location" do
      valid_attrs = %{city_id: "some city_id", note: "some note"}

      assert {:ok, %MockLocation{} = mock_location} = LiveSelectTest.create_mock_location(valid_attrs)
      assert mock_location.city_id == "some city_id"
      assert mock_location.note == "some note"
    end

    test "create_mock_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LiveSelectTest.create_mock_location(@invalid_attrs)
    end

    test "update_mock_location/2 with valid data updates the mock_location" do
      mock_location = mock_location_fixture()
      update_attrs = %{city_id: "some updated city_id", note: "some updated note"}

      assert {:ok, %MockLocation{} = mock_location} = LiveSelectTest.update_mock_location(mock_location, update_attrs)
      assert mock_location.city_id == "some updated city_id"
      assert mock_location.note == "some updated note"
    end

    test "update_mock_location/2 with invalid data returns error changeset" do
      mock_location = mock_location_fixture()
      assert {:error, %Ecto.Changeset{}} = LiveSelectTest.update_mock_location(mock_location, @invalid_attrs)
      assert mock_location == LiveSelectTest.get_mock_location!(mock_location.id)
    end

    test "delete_mock_location/1 deletes the mock_location" do
      mock_location = mock_location_fixture()
      assert {:ok, %MockLocation{}} = LiveSelectTest.delete_mock_location(mock_location)
      assert_raise Ecto.NoResultsError, fn -> LiveSelectTest.get_mock_location!(mock_location.id) end
    end

    test "change_mock_location/1 returns a mock_location changeset" do
      mock_location = mock_location_fixture()
      assert %Ecto.Changeset{} = LiveSelectTest.change_mock_location(mock_location)
    end
  end
end
