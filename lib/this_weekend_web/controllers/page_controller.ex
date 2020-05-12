defmodule ThisWeekendWeb.PageController do
  use ThisWeekendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
