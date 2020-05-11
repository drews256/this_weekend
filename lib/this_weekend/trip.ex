import Ecto.Query

defmodule PointingParty.Trip do
  use Ecto.Schema

  import Ecto.Changeset

  alias PointingParty.{Repo, User, Trip, Location, Forecast, Activity}

  schema "trips" do
    belongs_to(:user, User)
    has_many(:locations, Location)
    has_many(:forecasts, Forecast)
    has_many(:activities, Activity)
    timestamps()
  end

  def create(attrs) do
    changeset = changeset(%Trip{}, attrs)

    if changeset.valid? do
      account = apply_changes(changeset)
      {:ok, account}
    else
      {:error, %{changeset | action: :insert}}
    end
  end

  def changeset(trip, attrs \\ %{}) do
    trip
    |> cast(attrs, [:user_id])
    |> validate_required(:user_id)
  end

  def trip_with_locations_and_forecasts(id) do
    locations_query = from l in Location, order_by: l.inserted_at
    forecasts_query = from f in Forecast, order_by: fragment("(forecast_data->>'dt')::numeric")

    Repo.get(Trip, id)
    |> Repo.preload(
      locations: locations_query,
      locations: [forecasts: forecasts_query]
    )
  end
end
