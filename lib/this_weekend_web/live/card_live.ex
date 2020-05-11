defmodule PointingPartyWeb.CardLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias PointingPartyWeb.Router.Helpers, as: Routes
  alias PointingParty.WeatherClient
  alias PointingParty.{Card, VoteCalculator}
  alias PointingParty.Trip.{Builder}
  alias PointingPartyWeb.{Endpoint, Presence, LocationLive}

  @topic "this_weekend"

  def render(assigns) do
    Phoenix.View.render(PointingPartyWeb.CardView, "index.html", assigns)
  end

  def mount(_params, %{"email" => email, "trip_id" => trip_id}, socket) do
    Endpoint.subscribe(@topic)
    {:ok, _} = Presence.track(self(), @topic, email, %{points: nil})

    assigns = [
      step: %{
        title: "Step 1",
        description: "Tell us your name and what kind of activity you want to do"
      },
      activities: MapSet.new(),
      activity_names: MapSet.new(),
      activity: nil,
      trip_id: trip_id,
      username: email,
      users: Presence.list(@topic)
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("activities_selected", _form, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.live_path(socket, LocationLive, %{
           trip_id: socket.assigns.trip_id
         })
     )}
  end

  def handle_event("select_activity", %{"type" => activity}, socket) do
    case Builder.add_activity(%{trip_id: socket.assigns.trip_id, name: activity}) do
      {:ok, activity} ->
        {:noreply,
         assign(socket,
           activities: MapSet.put(socket.assigns.activities, activity),
           activity_names: MapSet.put(socket.assigns.activity_names, activity.name)
         )}

      {:error, _} ->
        {:noreply, assign(socket, activities: socket.assigns.activities)}
    end
  end

  def handle_event("unselect_activity", %{"type" => activity}, socket) do
    activity_to_remove =
      Enum.find(socket.assigns.activities, fn activity_map -> activity_map.name == activity end)

    case Builder.remove_activity(activity_to_remove.id) do
      {:ok, activity} ->
        {:noreply,
         assign(socket,
           activities: MapSet.delete(socket.assigns.activities, activity),
           activity_names: MapSet.delete(socket.assigns.activity_names, activity.name)
         )}

      {:error, error} ->
        IO.inspect(error)
        {:noreply, assign(socket, activities: socket.assigns.activities)}
    end
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, users: Presence.list(@topic))}
  end
end
