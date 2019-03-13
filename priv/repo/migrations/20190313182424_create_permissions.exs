defmodule Heimdall.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :bit, :integer
      add :name, :string

      timestamps()
    end

    create unique_index(:permissions, [:bit])
  end
end
