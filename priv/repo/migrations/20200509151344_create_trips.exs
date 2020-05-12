defmodule ThisWeekend.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add :user_id, :integer

      timestamps()
    end
  end
end
