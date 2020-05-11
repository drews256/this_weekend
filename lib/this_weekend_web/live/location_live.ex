require Protocol
Protocol.derive(Jason.Encoder, Geocoder.Coords)
Protocol.derive(Jason.Encoder, Geocoder.Location)
Protocol.derive(Jason.Encoder, Geocoder.Bounds)

defmodule PointingPartyWeb.LocationLive do
  use Phoenix.LiveView

  alias PointingParty.{Trip, Repo, WeatherClient}
  alias PointingPartyWeb.{GoToLive, Endpoint, Presence}
  alias PointingParty.Trip.Builder

  alias PointingPartyWeb.Router.Helpers, as: Routes

  @topic "this_weekend"

  def render(assigns) do
    Phoenix.View.render(PointingPartyWeb.LocationView, "index.html", assigns)
  end

  def mount(params, %{"email" => email}, socket) do
    Endpoint.subscribe(@topic)

    trip = Trip.trip_with_locations_and_forecasts(params["trip_id"])

    assigns = [
      step: %{
        title: "Step 2",
        description: "Now that we know what you want to do, where do you want to go?"
      },
      trip_id: params["trip_id"],
      activities: params["activities"],
      locations: trip.locations,
      location_ids: [],
      forecasts: trip.forecasts,
      username: email,
      error: nil
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("add_location", %{"location" => %{"location" => location}}, socket) do
    case Geocoder.call(location) do
      {:ok, coordinates} ->
        uuid = Ecto.UUID.generate()

        case Builder.add_location(%{
               trip_id: socket.assigns.trip_id,
               geocode_data: coordinates
             }) do
          {:ok, new_location} ->
            Endpoint.broadcast(@topic, "new_location", %{
              new_location: new_location,
              coordinates: coordinates,
              uuid: uuid
            })

            trip = Trip.trip_with_locations_and_forecasts(socket.assigns.trip_id)

            {:noreply, assign(socket, :locations, trip.locations)}

          {:error, error} ->
            IO.inspect(error)
        end

      {:error, issue} ->
        IO.inspect(issue)
        {:noreply, assign(socket, error: "Can't find that location")}
    end
  end

  def handle_event("where_do_i_go", _, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.live_path(socket, GoToLive, %{trip_id: socket.assigns.trip_id})
     )}
  end

  def handle_info(
        %{
          event: "new_location",
          payload: %{
            new_location: new_location,
            coordinates: %Geocoder.Coords{lat: lat, lon: lon},
            uuid: uuid
          }
        },
        socket
      ) do
    case WeatherClient.weather(%{lat: Float.to_string(lat), lon: Float.to_string(lon)}) do
      {:ok, weather} ->
        Enum.map(Jason.decode!(weather.body)["list"], fn forecast ->
          Builder.add_forecast(%{
            trip_id: socket.assigns.trip_id,
            location_id: new_location.id,
            forecast_data: forecast
          })
        end)

        trip = Trip.trip_with_locations_and_forecasts(socket.assigns.trip_id)

        {:noreply, assign(socket, :locations, trip.locations)}

      {:error, issue} ->
        {:noreply, assign(socket, error: "Can't find weather for that location")}
    end
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, users: Presence.list(@topic))}
  end
end
