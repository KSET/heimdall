defmodule Heimdall.Log do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Heimdall.Equipment.Door
  alias Heimdall.Account.User
  alias Heimdall.{Log, Repo, Account}
  alias Heimdall.Relations.DoorUser

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
        access_granted: success,
        inserted_at: logged
      }) do
    %{
      id: id,
      user_id: user_id,
      user: User.to_map(user),
      door_id: door_id,
      door: Door.to_map(door),
      success: success,
      logged: logged
    }
  end

  def to_map(_), do: %{}

  @spec owned_query(User.t()) :: Ecto.Query.t()
  def owned_query(%User{id: id} = user) do
    user
    |> Account.has_permission("log:view-all")
    |> owned_query(id)
  end

  defp owned_query(true, _user_id) do
    from(Log)
  end

  defp owned_query(false, user_id) do
    owned_door_ids =
      from(
        u in User,
        left_join: du in DoorUser,
        on: du.user_id == u.id,
        select: du.door_id,
        where: u.id == ^user_id and du.owner == true
      )

    from(
      log in Log,
      join: s in subquery(owned_door_ids),
      on: s.door_id == log.door_id or log.user_id == ^user_id
    )
  end

  @spec add_attempt(%{door: integer(), success: boolean(), user: integer()}) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_attempt(%{user: user_id, door: door_id, success: success}) do
    %Log{}
    |> changeset(%{user_id: user_id, door_id: door_id, access_granted: success})
    |> Repo.insert()
  end
end
