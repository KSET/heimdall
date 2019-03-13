defmodule Heimdall.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :permissions, :integer

      timestamps()
    end

  end
end
