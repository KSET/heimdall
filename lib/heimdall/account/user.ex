defmodule Heimdall.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Heimdall.Account.{User, Role}
  alias Heimdall.Relations.DoorUser

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

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :password, :code])
    |> validate_required([:first_name, :last_name, :password, :code, :role_id])
    |> unique_constraint(:code)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
