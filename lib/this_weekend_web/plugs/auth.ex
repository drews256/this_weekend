defmodule ThisWeekendWeb.Plugs.Auth do
  import Phoenix.Controller
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    case authenticate(conn) do
      nil ->
        conn
        |> redirect(to: "/login")
        |> halt()

      email ->
        assign(conn, :email, email)
    end
  end

  defp authenticate(conn) do
    get_session(conn, :email)
  end
end
