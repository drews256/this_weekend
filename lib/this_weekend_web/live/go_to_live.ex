defmodule PointingPartyWeb.GoToLive do
  use Phoenix.LiveView

  alias PointingParty.WeatherClient
  alias PointingPartyWeb.{Endpoint, Presence}
  alias PointingParty.{Trip, WeatherClient, Location, Forecast}
  alias PointingParty.Trip.Reccomendation

  alias PointingPartyWeb.Router.Helpers, as: Routes

  @topic "this_weekend"

  def render(assigns) do
    Phoenix.View.render(PointingPartyWeb.GoToView, "index.html", assigns)
  end

  def mount(params, %{"email" => email}, socket) do
    Endpoint.subscribe(@topic)

    reccomendations =
      Reccomendation.reccomendation(params["trip_id"])
      |> Enum.sort(fn a, b -> a.rating < b.rating end)

    trip = Trip.trip_with_locations_and_forecasts(params["trip_id"])

    assigns = [
      step: %{
        title: "Step 3",
        description:
          "We'll help you decide what kind of adventure you should go on based on the weather."
      },
      trip_id: params["trip_id"],
      activities: params["activities"],
      locations: trip.locations,
      forecasts: trip.forecasts,
      username: email,
      reccomendations: reccomendations,
      reccomendation: %{activity: "mountain-biking", location: 'Durango', forecast: 'Sunny'},
      error: nil
    ]

    {:ok, assign(socket, assigns)}
  end
end
