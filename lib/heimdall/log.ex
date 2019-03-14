defmodule Heimdall.Log do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.{User, Door}

  schema "logs" do
    field(:access_granted, :boolean, default: false)
    field(:date_logged, :utc_datetime)

    belongs_to(:user, User)
    belongs_to(:door, Door)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:access_granted, :date_logged])
    |> validate_required([:access_granted, :date_logged])
  end
end
