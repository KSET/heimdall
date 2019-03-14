defmodule Heimdall.Repo.Migrations.Log do
  use Ecto.Migration

  def change do
    alter table("logs") do
      remove(:date_logged)
    end
  end
end
