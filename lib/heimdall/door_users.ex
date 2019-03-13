defmodule Heimdall.DoorUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "door_users" do
    field(:date_assigned, :utc_datetime)
    field(:date_expires, :utc_datetime, default: nil)
    field(:opens_remaining, :integer, default: nil)
    field(:door_id, :id)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(door_users, attrs) do
    door_users
    |> cast(attrs, [:opens_remaining, :date_expires, :date_assigned])
    |> validate_required([:date_assigned])
  end
end
