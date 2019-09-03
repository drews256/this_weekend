defmodule PointingPartyWeb.LocationLive do
  alias PointingPartyWeb.Router.Helpers, as: Routes
  use Phoenix.LiveView

  alias PointingParty.WeatherClient
  alias PointingParty.{Card, VoteCalculator}
  alias PointingPartyWeb.{Endpoint, Presence}

  @topic "pointing_party"

  def render(assigns) do
    Phoenix.View.render(PointingPartyWeb.LocationView, "index.html", assigns)
  end

  def mount(params, socket) do
    Endpoint.subscribe(@topic)
    assigns = [
      step: %{ title: "Step 2", description: "Now that we know what you want to do, where do you want to go?" },
      location: nil,
      activities: params.activities,
      locations: %{},
      forecasts: MapSet.new(),
      username: params.username,
      error: nil
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("add_location", %{ "location" => %{ "location" => location }}, socket) do
    case Geocoder.call(location) do
      { :ok, coordinates } ->
        uuid = Ecto.UUID.generate()
        Endpoint.broadcast(@topic, "new_location", %{ coordinates: coordinates, uuid: uuid })
        locations_map = socket.assigns.locations
          |> Map.put_new(uuid, %{ geocode: coordinates, searched_location: location, weather: %{ "list" => [] } })
        { :noreply, assign(socket, locations: locations_map ) }
      { :error, issue} ->
        IO.inspect(issue)
        { :noreply, assign(socket, error: "Can't find that location") }
    end
  end

  def handle_info(%{event: "new_location", payload: %{ coordinates: %Geocoder.Coords{ lat: lat, lon: lon }, uuid: uuid }}, socket) do
    case WeatherClient.weather(%{lat: Float.to_string(lat), lon: Float.to_string(lon)}) do
      { :ok, weather } ->
        {:ok, new_map} = socket.assigns.locations
          |> Map.fetch(uuid)

         IO.inspect(Jason.decode!(weather.body))
         updated_location = new_map
          |> Map.merge(%{ weather: Jason.decode!(weather.body) })
        { :noreply, assign(socket, locations: Map.put(socket.assigns.locations, uuid, updated_location) ) }
      { :error, issue} ->
        IO.inspect(issue)
        { :noreply, assign(socket, error: "Can't find weather for that location") }
    end
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, users: Presence.list(@topic))}
  end
end
