defmodule Heimdall.Door do
  use Ecto.Schema
  import Ecto.Changeset

  schema "doors" do
    field(:code, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(door, attrs) do
    door
    |> cast(attrs, [:code, :name])
    |> validate_required([:code, :name])
    |> unique_constraint(:code)
  end
end
