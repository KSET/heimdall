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
  end
end
