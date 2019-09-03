defmodule PointingParty.WeatherClient do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.openweathermap.org/data/2.5")
  @app_id "539756b83366c299af98e440614ce980"

  def weather(zip_code, country_code) do
    {:ok, response} = get("/forecast?zip=" <> zip_code <> "," <> country_code <> "&APPID=" <> @app_id)
  end

  def weather(%{ lat: lat, lon: lon }) do
    get("/forecast?lat=" <> lat <> "&" <> "lon=" <> lon <> "&units=imperial" <> "&APPID=" <> @app_id)
  end
end
