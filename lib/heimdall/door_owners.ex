defmodule Heimdall.DoorOwners do
  use Ecto.Schema
  import Ecto.Changeset


  schema "door_owners" do
    field :date_assigned, :utc_datetime
    field :door_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(door_owners, attrs) do
    door_owners
    |> cast(attrs, [:date_assigned])
    |> validate_required([:date_assigned])
  end
end
