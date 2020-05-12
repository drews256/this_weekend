defmodule ThisWeekend.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias ThisWeekend.{User, Trip, Repo}

  schema "users" do
    field :email, :string
    has_many(:trips, Trip)
    timestamps()
  end

  def create(attrs) do
    changeset = changeset(%User{}, attrs)
    IO.inspect(changeset)

    if changeset.valid? do
      user = apply_changes(changeset)
      {:ok, user}
    else
      {:error, %{changeset | action: :insert}}
    end
  end

  def find_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def save(user) do
    Repo.insert(user)
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
