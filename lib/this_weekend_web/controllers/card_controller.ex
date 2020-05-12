defmodule ThisWeekendWeb.CardController do
  use ThisWeekendWeb, :controller

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    %{assigns: %{username: username}} = conn

    live_render(conn, ThisWeekendWeb.CardLive, session: %{username: username})
  end
end
