defmodule Heimdall.Repo.Migrations.CreateDoors do
  use Ecto.Migration

  def change do
    create table(:doors) do
      add :code, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:doors, [:code])
  end
end
