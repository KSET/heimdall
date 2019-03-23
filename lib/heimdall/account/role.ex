defmodule Heimdall.Account.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias Heimdall.Account.Role

  schema "roles" do
    field(:name, :string)
    field(:permissions, :integer)

    timestamps()
  end

  @spec to_map(Role.t() | any()) :: map()
  def to_map(%Role{} = role), do: role |> Map.take([:id, :name, :permission])
  def to_map(_role), do: %{}

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name, :permissions])
    |> unique_constraint(:name)
  end
end
