defmodule LocalityWeb.MockLocationLive.FormComponent do
  use LocalityWeb, :live_component

  alias Locality.LiveSelectTest
  alias Locality.Locations.City

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage mock_location records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="mock_location-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:note]} type="text" label="Note" />

        <.live_select
          field={@form[:city_id]}
          label="City"
          placeholder="Where are you?"
          debounce={200}
          dropdown_extra_class="bg-white max-h-48 overflow-y-scroll"
          mode={:single}
          update_min_len={2}
          phx-target={@myself}
          value_mapper={&value_mapper/1}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Mock location</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{mock_location: mock_location} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(LiveSelectTest.change_mock_location(mock_location))
     end)}
  end

  @impl true
  def handle_event("validate", %{"mock_location" => mock_location_params}, socket) do
    changeset = LiveSelectTest.change_mock_location(socket.assigns.mock_location, mock_location_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"mock_location" => mock_location_params}, socket) do
    save_mock_location(socket, socket.assigns.action, mock_location_params)
  end

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    cities = Locality.Locations.city_search(text)

    send_update(LiveSelect.Component, id: live_select_id, options: cities)

    {:noreply, socket}
  end

  def handle_event("focus", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("clear", %{"id" => id}, socket) do
    send_update(LiveSelect.Component, options: [], id: id)

    {:noreply, socket}
  end

  defp value_mapper(location_id) when is_bitstring(location_id) do
    City.city_option_for_select(location_id)
  end

  defp value_mapper(value), do: value

  defp save_mock_location(socket, :edit, mock_location_params) do
    case LiveSelectTest.update_mock_location(socket.assigns.mock_location, mock_location_params) do
      {:ok, mock_location} ->
        IO.inspect(mock_location)
        notify_parent({:saved, mock_location})

        {:noreply,
         socket
         |> put_flash(:info, "Mock location updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_mock_location(socket, :new, mock_location_params) do
    case LiveSelectTest.create_mock_location(mock_location_params) do
      {:ok, mock_location} ->
        notify_parent({:saved, mock_location})

        {:noreply,
         socket
         |> put_flash(:info, "Mock location created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
