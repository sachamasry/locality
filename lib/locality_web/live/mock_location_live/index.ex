defmodule LocalityWeb.MockLocationLive.Index do
  use LocalityWeb, :live_view

  alias Locality.LiveSelectTest
  alias Locality.LiveSelectTest.MockLocation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :mock_locations, LiveSelectTest.list_mock_locations_with_city())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Mock location")
    |> assign(:mock_location, LiveSelectTest.get_mock_location!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Mock location")
    |> assign(:mock_location, %MockLocation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Mock locations")
    |> assign(:mock_location, nil)
  end

  @impl true
  def handle_info({LocalityWeb.MockLocationLive.FormComponent, {:saved, mock_location}}, socket) do
    mock_location = LiveSelectTest.get_mock_location_with_city!(mock_location.id)
    {:noreply, stream_insert(socket, :mock_locations, mock_location)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    mock_location = LiveSelectTest.get_mock_location!(id)
    {:ok, _} = LiveSelectTest.delete_mock_location(mock_location)

    {:noreply, stream_delete(socket, :mock_locations, mock_location)}
  end
end
