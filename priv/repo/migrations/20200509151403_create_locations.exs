defmodule PointingParty.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :trip_id, :integer
      add :geocode_data, :jsonb

      timestamps()
    end
  end
end
