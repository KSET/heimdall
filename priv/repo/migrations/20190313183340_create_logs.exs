defmodule Heimdall.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add(:access_granted, :boolean, default: false, null: false)
      add(:door_code, :string, null: false)
      add(:user_code, :string, null: false)

      timestamps()
    end
  end
end
