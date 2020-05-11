defmodule PointingPartyWeb.SessionController do
  use PointingPartyWeb, :controller

  alias PointingParty.{Account, Account.Auth}

  def new(conn, _params) do
    changeset = Account.changeset(%Account{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, params) do
    case Auth.login(params["account"]) do
      {:ok, %{email: email, trip_id: trip_id}} ->
        conn
        |> assign(:step, %{title: "Step 1"})
        |> put_session(:email, email)
        |> put_session(:trip_id, trip_id)
        |> redirect(to: "/cards")
        |> halt()

      {:error, _} ->
        render(conn, "new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/login")
    |> halt()
  end
end
