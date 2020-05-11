defmodule PointingPartyWeb.LocationController do
  use PointingPartyWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, params) do
    %{assigns: %{username: username}} = conn

    activities = params["activities"]
    live_render(conn, PointingPartyWeb.LocationLive, session: %{username: username, activities: activities})
  end
end
