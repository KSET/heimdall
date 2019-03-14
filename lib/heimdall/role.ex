defmodule Heimdall.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field(:name, :string)
    field(:permissions, :integer)

    timestamps()
  end

  @spec list_permissions(integer()) :: [String.t()]
  def list_permissions(id) when is_integer(id) do
    Heimdall.Repo.query!(
      "select p.name from permissions p inner join roles r on p.bit & r.permissions > 0 where r.id = (select role_id from users where id = $1)",
      [id]
    ).rows
    |> Enum.concat()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name, :permissions])
    |> unique_constraint(:name)
  end
end
