defmodule ThisWeekendWeb.Presence do
  use Phoenix.Presence, otp_app: :this_weekend,
                        pubsub_server: ThisWeekend.PubSub
end
