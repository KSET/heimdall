defmodule Heimdall.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:code, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:password, :string)
    field(:role_id, :id)
    field(:created_by_id, :id)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :password, :code])
    |> validate_required([:first_name, :last_name, :password, :code])
    |> unique_constraint(:code)
  end
end
