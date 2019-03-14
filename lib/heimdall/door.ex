defmodule Heimdall.Door do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.{Log, DoorOwner, DoorUser}

  schema "doors" do
    field(:code, :string)
    field(:name, :string)

    has_many(:log, Log)

    has_many(:door_owners, DoorOwner)
    has_many(:door_users, DoorUser)

    has_many(:owners, through: [:door_owners, :user])
    has_many(:users, through: [:door_users, :user])

    timestamps()
  end

  @doc false
  def changeset(door, attrs) do
    door
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
    |> unique_constraint(:code)
  end
end
