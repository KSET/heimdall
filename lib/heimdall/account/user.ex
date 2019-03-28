defmodule Heimdall.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.Account.{User, Role}
  alias Heimdall.Relations.DoorUser
  alias Heimdall.Log

  schema "users" do
    field(:code, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:password, :string)

    belongs_to(:created_by, User)
    has_many(:created, User, foreign_key: :created_by_id)

    belongs_to(:role, Role)

    has_many(:door_users, DoorUser)
    has_many(:doors, through: [:door_users, :door])

    has_many(:logs, Log, foreign_key: :user_code, references: :code)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :password, :code, :role_id, :created_by_id])
    |> unique_constraint(:code)
    |> put_pass_hash()
  end

  @spec to_map(User.t() | any()) :: map()
  def to_map(user), do: to_map(user, false)

  @spec to_map(User.t() | any(), boolean()) :: map()
  def to_map(%User{} = user, with_sensitive_info) do
    keys = map_keys(with_sensitive_info)

    user
    |> Map.take(keys)
    |> fix_role()
  end

  def to_map(_user, _sensitive), do: %{}

  defp map_keys(false), do: [:code, :first_name, :last_name, :role_id, :role]
  defp map_keys(true), do: [:password] ++ map_keys(false)

  defp fix_role(map), do: %{map | role: Role.to_map(map.role)}

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
