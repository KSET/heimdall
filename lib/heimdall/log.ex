defmodule Heimdall.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field(:access_granted, :boolean, default: false)
    field(:date_logged, :utc_datetime)
    field(:door_id, :id)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:access_granted, :date_logged])
    |> validate_required([:access_granted, :date_logged])
  end
end
