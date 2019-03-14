defmodule Heimdall.DoorUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.{User, Door}

  schema "door_users" do
    field(:date_assigned, :utc_datetime)
    field(:date_expires, :utc_datetime, default: nil)
    field(:opens_remaining, :integer, default: nil)

    belongs_to(:user, User)
    belongs_to(:door, Door)

    timestamps()
  end

  @doc false
  def changeset(door_users, attrs) do
    door_users
    |> cast(attrs, [:opens_remaining, :date_expires, :date_assigned])
    |> validate_required([:date_assigned])
  end
end
