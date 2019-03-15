defmodule Heimdall.Log do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.Door
  alias Heimdall.Account.User

  schema "logs" do
    field(:access_granted, :boolean, default: false)

    belongs_to(:user, User)
    belongs_to(:door, Door)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:access_granted])
    |> validate_required([:access_granted, :user_id, :door_id])
  end
end
