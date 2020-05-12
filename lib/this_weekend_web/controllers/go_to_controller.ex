defmodule ThisWeekendWeb.GoToController do
  use ThisWeekendWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, params) do
    %{assigns: %{username: username}} = conn

    activities = params["activities"]
    locations = params["locations"]

    live_render(conn, ThisWeekendWeb.GoToLive, session: %{
      username: username, activities: activities, locations: locations
    })
  end
end
