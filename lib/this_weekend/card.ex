defmodule ThisWeekend.Card do
  use Ecto.Schema

  import Ecto.Changeset

  @pointing_scale [0, 1, 3, 5]

  schema "cards" do
    field :description, :string
    field :points, :integer
    field :title, :string

    timestamps()
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :points])
    |> validate_required([:title, :description])
    |> validate_inclusion(:points, @pointing_scale)
  end

  def cards do
    :this_weekend
    |> Application.get_env(:cards)
    |> Enum.map(&struct(__MODULE__, &1))
  end

  def points_range, do: @pointing_scale
end
