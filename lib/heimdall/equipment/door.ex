defmodule Heimdall.Equipment.Door do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.Log
  alias Heimdall.Relations.DoorUser
  alias Heimdall.Equipment.Door

  schema "doors" do
    field(:code, :string)
    field(:name, :string)

    has_many(:logs, Log, foreign_key: :door_code, references: :code)

    has_many(:door_users, DoorUser)
    has_many(:users, through: [:door_users, :user])

    timestamps()
  end

  @spec to_map(Door.t() | any()) :: map()
  def to_map(%Door{} = door), do: door |> Map.take([:code, :name])
  def to_map(_), do: %{}

  @doc false
  def changeset(door, attrs) do
    door
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
    |> unique_constraint(:code)
    |> unique_constraint(:name)
  end
end
