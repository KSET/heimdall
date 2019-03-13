defmodule Heimdall.Repo.Migrations.CreateDoorUsers do
  use Ecto.Migration

  def change do
    create table(:door_users) do
      add :opens_remaining, :integer
      add :date_expires, :utc_datetime
      add :date_assigned, :utc_datetime
      add :door_id, references(:doors, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:door_users, [:door_id])
    create index(:door_users, [:user_id])
  end
end
