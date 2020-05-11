defmodule PointingPartyWeb.Presence do
  use Phoenix.Presence, otp_app: :this_weekend,
                        pubsub_server: PointingParty.PubSub
end
