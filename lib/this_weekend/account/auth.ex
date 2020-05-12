defmodule ThisWeekend.Account.Auth do
  alias ThisWeekend.{User, Repo}
  alias ThisWeekend.Trip.{Builder}

  def login(params) do
    user = User.find_by_email(params["username"])

    case user do
      %User{email: email} ->
        {:ok, trip} = Builder.create_trip(Map.from_struct(user))
        {:ok, %{email: email, trip_id: trip.id}}

      nil ->
        new_user = User.create(%{email: params["username"]})
        {:ok, user} = save_user(new_user)
        {:ok, trip} = Builder.create_trip(Map.from_struct(user))
        {:ok, %{email: user.email, trip_id: trip.id}}
    end
  end

  def save_user({:ok, user_changeset}) do
    Repo.insert(user_changeset)
  end
end
