defmodule ThisWeekend.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string
      add :trip_id, :integer

      timestamps()
    end
  end
end
