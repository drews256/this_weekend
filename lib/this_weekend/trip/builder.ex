defmodule ThisWeekend.Trip.Builder do
  alias ThisWeekend.{Forecast, Location, Trip, Repo, Activity}

  def create_trip(%{id: user_id}) do
    Trip.create(%{user_id: user_id})
    |> save_trip
  end

  def add_activity(%{trip_id: trip_id, name: name}) do
    {:ok, activity_changeset} = Activity.create(%{trip_id: trip_id, name: name})

    Repo.insert(activity_changeset)
  end

  def remove_activity(activity_id) do
    activity = Repo.get!(Activity, activity_id)

    Repo.delete(activity)
  end

  def add_location(%{trip_id: trip_id, geocode_data: geocode_data}) do
    {:ok, location_changeset} = Location.create(%{trip_id: trip_id, geocode_data: geocode_data})

    Repo.insert(location_changeset)
  end

  def add_forecast(%{trip_id: trip_id, location_id: location_id, forecast_data: forecast_data}) do
    case Forecast.create(%{
           location_id: location_id,
           trip_id: trip_id,
           forecast_data: forecast_data
         }) do
      {:ok, forecast_changeset} -> Repo.insert(forecast_changeset)
      {:error, error} -> IO.inspect(error)
    end
  end

  def remove_location(location_id) do
    location = Repo.get!(Location, location_id)

    Repo.delete(location)
  end

  def save_trip({:ok, trip_changeset}) do
    Repo.insert(trip_changeset)
  end

  def save_trip({:error, trip_changeset}) do
    IO.inspect(trip_changeset)
  end
end
