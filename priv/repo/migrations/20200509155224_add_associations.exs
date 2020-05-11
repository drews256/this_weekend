defmodule PointingParty.Repo.Migrations.AddAssociations do
  use Ecto.Migration

  def change do
    alter table("trips") do
      add :user_id, :integer
    end
  end
end
