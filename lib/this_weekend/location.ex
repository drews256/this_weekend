defmodule ThisWeekend.Location do
  use Ecto.Schema

  import Ecto.Changeset

  alias ThisWeekend.{Forecast, Location, Trip}

  schema "locations" do
    has_many(:forecasts, Forecast)

    field :geocode_data, :map

    belongs_to(:trip, Trip)
    timestamps()
  end

  def create(attrs) do
    changeset = changeset(%Location{}, attrs)

    if changeset.valid? do
      location = apply_changes(changeset)
      {:ok, location}
    else
      {:error, %{changeset | action: :insert}}
    end
  end

  def changeset(location, attrs \\ %{}) do
    location
    |> cast(attrs, [:geocode_data, :trip_id])
    |> validate_required([:geocode_data, :trip_id])
  end
end
