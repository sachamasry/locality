defmodule LocalityWeb.MockLocationLiveTest do
  use LocalityWeb.ConnCase

  import Phoenix.LiveViewTest
  import Locality.LiveSelectTestFixtures

  @create_attrs %{city_id: "some city_id", note: "some note"}
  @update_attrs %{city_id: "some updated city_id", note: "some updated note"}
  @invalid_attrs %{city_id: nil, note: nil}

  defp create_mock_location(_) do
    mock_location = mock_location_fixture()
    %{mock_location: mock_location}
  end

  describe "Index" do
    setup [:create_mock_location]

    test "lists all mock_locations", %{conn: conn, mock_location: mock_location} do
      {:ok, _index_live, html} = live(conn, ~p"/mock_locations")

      assert html =~ "Listing Mock locations"
      assert html =~ mock_location.city_id
    end

    test "saves new mock_location", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/mock_locations")

      assert index_live |> element("a", "New Mock location") |> render_click() =~
               "New Mock location"

      assert_patch(index_live, ~p"/mock_locations/new")

      assert index_live
             |> form("#mock_location-form", mock_location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#mock_location-form", mock_location: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/mock_locations")

      html = render(index_live)
      assert html =~ "Mock location created successfully"
      assert html =~ "some city_id"
    end

    test "updates mock_location in listing", %{conn: conn, mock_location: mock_location} do
      {:ok, index_live, _html} = live(conn, ~p"/mock_locations")

      assert index_live |> element("#mock_locations-#{mock_location.id} a", "Edit") |> render_click() =~
               "Edit Mock location"

      assert_patch(index_live, ~p"/mock_locations/#{mock_location}/edit")

      assert index_live
             |> form("#mock_location-form", mock_location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#mock_location-form", mock_location: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/mock_locations")

      html = render(index_live)
      assert html =~ "Mock location updated successfully"
      assert html =~ "some updated city_id"
    end

    test "deletes mock_location in listing", %{conn: conn, mock_location: mock_location} do
      {:ok, index_live, _html} = live(conn, ~p"/mock_locations")

      assert index_live |> element("#mock_locations-#{mock_location.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#mock_locations-#{mock_location.id}")
    end
  end

  describe "Show" do
    setup [:create_mock_location]

    test "displays mock_location", %{conn: conn, mock_location: mock_location} do
      {:ok, _show_live, html} = live(conn, ~p"/mock_locations/#{mock_location}")

      assert html =~ "Show Mock location"
      assert html =~ mock_location.city_id
    end

    test "updates mock_location within modal", %{conn: conn, mock_location: mock_location} do
      {:ok, show_live, _html} = live(conn, ~p"/mock_locations/#{mock_location}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Mock location"

      assert_patch(show_live, ~p"/mock_locations/#{mock_location}/show/edit")

      assert show_live
             |> form("#mock_location-form", mock_location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#mock_location-form", mock_location: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/mock_locations/#{mock_location}")

      html = render(show_live)
      assert html =~ "Mock location updated successfully"
      assert html =~ "some updated city_id"
    end
  end
end
