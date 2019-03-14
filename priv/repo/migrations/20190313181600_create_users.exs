defmodule Heimdall.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :password, :string
      add :code, :string
      add :role_id, references(:roles, on_delete: :restrict)
      add :created_by_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:users, [:code])
    create index(:users, [:role_id])
    create index(:users, [:created_by_id])
  end
end
