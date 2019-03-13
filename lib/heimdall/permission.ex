defmodule Heimdall.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field(:bit, :integer)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:bit, :name])
    |> validate_required([:bit, :name])
    |> unique_constraint(:bit)
  end
end
