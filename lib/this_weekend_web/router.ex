defmodule ThisWeekendWeb.Router do
  use ThisWeekendWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ThisWeekendWeb do
    pipe_through :browser
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/", PageController, :index
  end

  scope "/", ThisWeekendWeb do
    pipe_through [:browser, ThisWeekendWeb.Plugs.Auth]
    live "/cards", CardLive, layout: {ThisWeekendWeb.LayoutView, :live}
    live "/locations", LocationLive, layout: {ThisWeekendWeb.LayoutView, :live}
    live "/options", GoToLive, layout: {ThisWeekendWeb.LayoutView, :live}
  end
end
