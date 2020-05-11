defmodule PointingParty.Forecast do
  use Ecto.Schema

  import Ecto.Changeset

  alias PointingParty.{Forecast, Location, Trip}

  schema "forecasts" do
    belongs_to(:location, Location)
    belongs_to(:trip, Trip)

    field :forecast_data, :map

    timestamps()
  end

  def create(attrs) do
    changeset = changeset(%Forecast{}, attrs)

    if changeset.valid? do
      forecast = apply_changes(changeset)
      {:ok, forecast}
    else
      {:error, %{changeset | action: :insert}}
    end
  end

  def changeset(forecast, attrs \\ %{}) do
    forecast
    |> cast(attrs, [:forecast_data, :location_id, :trip_id])
    |> validate_required([:forecast_data, :location_id, :trip_id])
  end
end
