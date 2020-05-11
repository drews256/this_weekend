import Ecto.Query

defmodule PointingParty.Trip.Reccomendation do
  alias PointingParty.{Forecast, Location, Trip, Repo, Activity}

  def rating_by_weather_type(weather_id) do
    # 200's thunderstorms
    # 300's drizzle
    # 300's drizzle
    # 500's rain
    # 600's snow
    # 700's atmosphere
    # 800's clear/clouds
    %{
      "200" => 700,
      "201" => 710,
      "202" => 720,
      "210" => 710,
      "211" => 740,
      "212" => 750,
      "221" => 760,
      "230" => 710,
      "231" => 710,
      "232" => 740,
      "300" => 500,
      "301" => 510,
      "302" => 520,
      "310" => 530,
      "311" => 540,
      "312" => 550,
      "313" => 560,
      "314" => 570,
      "321" => 580,
      "500" => 600,
      "501" => 610,
      "502" => 620,
      "503" => 630,
      "504" => 690,
      "511" => 690,
      "520" => 610,
      "521" => 620,
      "522" => 630,
      "531" => 640,
      "600" => 400,
      "601" => 410,
      "602" => 420,
      "611" => 450,
      "612" => 450,
      "613" => 450,
      "615" => 450,
      "616" => 700,
      "620" => 400,
      "621" => 500,
      "622" => 500,
      "701" => 100,
      "711" => 500,
      "721" => 100,
      "731" => 200,
      "741" => 100,
      "751" => 200,
      "761" => 200,
      "762" => 1000,
      "771" => 1000,
      "781" => 1000,
      "800" => 0,
      "801" => 10,
      "802" => 20,
      "803" => 30,
      "804" => 40
    }
    |> Map.get(weather_id)
  end

  def reccomendation(trip_id) do
    locations_query = from l in Location, order_by: l.inserted_at
    forecasts_query = from f in Forecast, order_by: fragment("(forecast_data->>'dt')::numeric")

    trip =
      Repo.get(Trip, trip_id)
      |> Repo.preload(
        locations: locations_query,
        locations: [forecasts: forecasts_query]
      )
      |> Repo.preload(:activities)

    Enum.reduce(trip.locations, [], fn location_and_forecasts, location_ratings ->
      total_low_temperature =
        Enum.map(location_and_forecasts.forecasts, fn forecast ->
          forecast
          |> Map.get(:forecast_data)
          |> Map.get("main", %{})
          |> Map.get("temp_min", "")
        end)
        |> Enum.sum()

      total_high_temperature =
        Enum.map(location_and_forecasts.forecasts, fn forecast ->
          forecast
          |> Map.get(:forecast_data)
          |> Map.get("main", %{})
          |> Map.get("temp_max", "")
        end)
        |> Enum.sum()

      weather_rating =
        Enum.map(location_and_forecasts.forecasts, fn forecast ->
          forecast
          |> Map.get(:forecast_data)
          |> Map.get("weather", %{})
          |> List.first()
          |> Map.get("id", "751")
          |> Integer.to_string()
          |> rating_by_weather_type
        end)
        |> Enum.sum()

      rating = round(weather_rating + total_high_temperature + total_low_temperature)
      IO.inspect(location_and_forecasts)
      location_ratings ++ [%{location: location_and_forecasts, rating: rating}]
    end)
  end
end
