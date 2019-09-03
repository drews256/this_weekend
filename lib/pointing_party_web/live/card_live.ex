defmodule PointingPartyWeb.CardLive do
  use Phoenix.LiveView

  alias PointingPartyWeb.Router.Helpers, as: Routes
  alias PointingParty.WeatherClient
  alias PointingParty.{Card, VoteCalculator}
  alias PointingPartyWeb.{Endpoint, Presence}

  @topic "pointing_party"

  def render(assigns) do
    Phoenix.View.render(PointingPartyWeb.CardView, "index.html", assigns)
  end

  def mount(%{username: username}, socket) do
    Endpoint.subscribe(@topic)
    {:ok, _} = Presence.track(self(), @topic, username, %{points: nil})

    assigns = [
      step: %{ title: "Step 1", description: "Tell us your name and what kind of activity you want to do" },
      activities: MapSet.new(),
      activity: nil,
      username: username,
      users: Presence.list(@topic),
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("activities_selected", form, socket) do
    {:stop,
    socket
    |> redirect(to: Routes.location_path(
      Endpoint, :index, %{username: socket.assigns.username, activities: MapSet.to_list(socket.assigns.activities)}))
    }
  end

  def handle_event("select_activity", activity, socket) do
    {:noreply, assign(socket, activities: MapSet.put(socket.assigns.activities, activity)) }
  end

  def handle_event("unselect_activity", activity, socket) do
    {:noreply, assign(socket, activities: MapSet.delete(socket.assigns.activities, activity)) }
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, users: Presence.list(@topic))}
  end
end
