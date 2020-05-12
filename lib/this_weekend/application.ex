defmodule ThisWeekend.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ThisWeekendWeb.Endpoint,
      ThisWeekendWeb.Presence,
      ThisWeekend.Repo
    ]

    opts = [strategy: :one_for_one, name: ThisWeekend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ThisWeekendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
