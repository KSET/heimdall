defmodule Heimdall.Repo.Migrations.AddMultipleLogTypes do
  use Ecto.Migration

  def change do
    alter table(:logs) do
      add(:type, :text)
    end
  end
end
