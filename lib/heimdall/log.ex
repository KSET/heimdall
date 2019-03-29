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

    belongs_to(:user, User, foreign_key: :user_code, references: :code, type: :string)
    belongs_to(:door, Door, foreign_key: :door_code, references: :code, type: :string)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:access_granted, :user_code, :door_code])
    |> validate_required([:access_granted, :user_code, :door_code])
  end

  @spec to_map(Log.t() | any()) :: map()
  def to_map(%Log{
        id: id,
        user_code: user_code,
        user: user,
        door_code: door_code,
        door: door,
        access_granted: success,
        inserted_at: logged
      }) do
    %{
      id: id,
      user_code: user_code,
      user: User.to_map(user),
      door_code: door_code,
      door: Door.to_map(door),
      success: success,
      logged: logged
    }
  end

  def to_map(_), do: %{}

  @spec owned_query(User.t()) :: Ecto.Query.t()
  def owned_query(%User{code: code} = user) do
    user
    |> Account.has_permission("log:view-all")
    |> owned_query(code)
  end

  defp owned_query(true, _user_code) do
    from(Log)
  end

  defp owned_query(false, user_code) do
    owned_door_codes =
      from(
        u in User,
        left_join: du in DoorUser,
        on: du.user_id == u.id,
        left_join: d in Door,
        on: du.door_id == d.id,
        select: d.code,
        where: u.code == ^user_code,
        where: du.owner == true
      )

    from(
      log in Log,
      distinct: true,
      join: s in subquery(owned_door_codes),
      on: s.code == log.door_code or log.user_code == ^user_code
    )
  end

  @spec add_attempt(%{door: integer(), success: boolean(), user: integer()}) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_attempt(%{user: user_code, door: door_code, success: success}) do
    %Log{}
    |> changeset(%{user_code: user_code, door_code: door_code, access_granted: success})
    |> Repo.insert()
  end
end
