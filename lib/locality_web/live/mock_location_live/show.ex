defmodule LocalityWeb.MockLocationLive.Show do
  use LocalityWeb, :live_view

  alias Locality.LiveSelectTest
  alias Locality.Locations.City

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    mock_location = LiveSelectTest.get_mock_location!(id)
    city_label = City.city_option_for_select(mock_location.city_id)

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:mock_location, mock_location)
      |> assign(:city_label, city_label.label)
    }
  end

  defp page_title(:show), do: "Show Mock location"
  defp page_title(:edit), do: "Edit Mock location"
end
