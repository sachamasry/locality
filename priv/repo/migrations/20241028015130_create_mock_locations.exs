defmodule Locality.Repo.Migrations.CreateMockLocations do
  use Ecto.Migration

  def change do
    create table(:mock_locations, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false

      add :city_id,
          references(:locations_cities,
            column: :id,
            type: :uuid,
            on_delete: :nothing,
            on_update: :nothing
          )

      add :note, :string

      timestamps(type: :utc_datetime)
    end
  end
end
