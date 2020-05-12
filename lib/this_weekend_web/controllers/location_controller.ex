defmodule ThisWeekendWeb.LocationController do
  use ThisWeekendWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, params) do
    %{assigns: %{username: username}} = conn

    activities = params["activities"]
    live_render(conn, ThisWeekendWeb.LocationLive, session: %{username: username, activities: activities})
  end
end
