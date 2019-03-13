defmodule Heimdall.Repo.Migrations.CreateDoorOwners do
  use Ecto.Migration

  def change do
    create table(:door_owners) do
      add :date_assigned, :utc_datetime
      add :door_id, references(:doors, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:door_owners, [:door_id])
    create index(:door_owners, [:user_id])
  end
end
