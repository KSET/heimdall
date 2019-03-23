defmodule Heimdall.Relations.DoorUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.Equipment.Door
  alias Heimdall.Account.User

  schema "door_users" do
    field(:date_assigned, :utc_datetime, virtual: true, source: :inserted_at)
    field(:date_expires, :utc_datetime, default: nil)
    field(:opens_remaining, :integer, default: nil)
    field(:owner, :boolean, default: false)

    belongs_to(:user, User)
    belongs_to(:door, Door)

    timestamps()
  end

  @doc false
  def changeset(door_users, attrs) do
    door_users
    |> cast(attrs, [:opens_remaining, :date_expires, :user_id, :door_id])
    |> validate_required([:user_id, :door_id])
  end
end
