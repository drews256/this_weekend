defmodule PointingParty.Activity do
  use Ecto.Schema

  import Ecto.Changeset

  alias PointingParty.{Activity, Trip}

  schema "activities" do
    field :name, :string
    belongs_to(:trip, Trip)
    timestamps()
  end

  def create(attrs) do
    changeset = changeset(%Activity{}, attrs)

    if changeset.valid? do
      activity = apply_changes(changeset)
      {:ok, activity}
    else
      {:error, %{changeset | action: :insert}}
    end
  end

  def changeset(activity, attrs \\ %{}) do
    activity
    |> cast(attrs, [:name, :trip_id])
    |> validate_required([:name, :trip_id])
  end
end
