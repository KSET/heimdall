defmodule Heimdall.Log do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.Equipment.Door
  alias Heimdall.Account.User
  alias Heimdall.{Log, Repo}

  schema "logs" do
    field(:access_granted, :boolean, default: false)

    belongs_to(:user, User)
    belongs_to(:door, Door)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:access_granted, :user_id, :door_id])
    |> validate_required([:access_granted, :user_id, :door_id])
  end

  @spec to_map(Log.t() | any()) :: map()
  def to_map(%Log{
        id: id,
        user_id: user_id,
        user: user,
        door_id: door_id,
        door: door,
        inserted_at: logged
      }) do
    %{
      id: id,
      user_id: user_id,
      user: User.to_map(user),
      door_id: door_id,
      door: Door.to_map(door),
      logged: logged
    }
  end

  def to_map(_), do: %{}

  @spec add_attempt(%{door: integer(), success: boolean(), user: integer()}) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_attempt(%{user: user_id, door: door_id, success: success}) do
    new_log =
      %Log{}
      |> changeset(%{user_id: user_id, door_id: door_id, access_granted: success})

    try do
      new_log
      |> Repo.insert()
    rescue
      Ecto.ConstraintError ->
        {:error, new_log}
    end
  end
end
