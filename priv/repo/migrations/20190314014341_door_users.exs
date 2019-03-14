defmodule Heimdall.Repo.Migrations.DoorUsers do
  use Ecto.Migration

  def change do
    alter table(:door_users) do
      add(:owner, :boolean, default: false, null: false)
      remove(:date_assigned)
    end
  end
end
