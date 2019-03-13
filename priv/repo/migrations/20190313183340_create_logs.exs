defmodule Heimdall.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :access_granted, :boolean, default: false, null: false
      add :date_logged, :utc_datetime
      add :door_id, references(:doors, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:logs, [:door_id])
    create index(:logs, [:user_id])
  end
end
