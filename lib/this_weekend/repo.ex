defmodule PointingParty.Repo do
  use Ecto.Repo,
    otp_app: :this_weekend,
    adapter: Ecto.Adapters.Postgres
end
