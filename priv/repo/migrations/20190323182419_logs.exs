defmodule Heimdall.Repo.Migrations.Logs do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE logs DROP CONSTRAINT logs_user_id_fkey")
    execute("ALTER TABLE logs DROP CONSTRAINT logs_door_id_fkey")
  end
end
