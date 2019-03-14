defmodule Heimdall.Repo.Migrations.DoorOwners do
  use Ecto.Migration

  def change do
    drop_if_exists(table(:door_owners))
  end
end
