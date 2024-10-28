defmodule Locality.LiveSelectTest.MockLocation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "mock_locations" do
    belongs_to(:city, City, type: Ecto.UUID)

    field :note, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mock_location, attrs) do
    mock_location
    |> cast(attrs, [:city_id, :note])
    |> foreign_key_constraint(:city_id)
    |> validate_required([:city_id])
  end
end
