defmodule Heimdall.DoorOwner do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.{User, Door}

  schema "door_owners" do
    field(:date_assigned, :utc_datetime)

    belongs_to(:user, User)
    belongs_to(:door, Door)

    timestamps()
  end

  @doc false
  def changeset(door_owners, attrs) do
    door_owners
    |> cast(attrs, [:date_assigned])
    |> validate_required([:date_assigned])
  end
end
