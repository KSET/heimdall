defmodule Heimdall.Repo.Migrations.AddBaseData do
  use Ecto.Migration
  use Bitwise

  def up do
    _permissions =
      [
        %{
          name: "user:modify",
          bit: 1 <<< 0
        },
        %{
          name: "user:assign",
          bit: 1 <<< 1
        },
        %{
          name: "door:modify",
          bit: 1 <<< 3
        },
        %{
          name: "door:assign",
          bit: 1 <<< 4
        },
        %{
          name: "door:bypass",
          bit: 1 <<< 5
        },
        %{
          name: "log:view",
          bit: 1 <<< 6
        },
        %{
          name: "log:view-all",
          bit: 1 <<< 7
        }
      ]
      |> Enum.map(&Heimdall.Account.create_permission/1)
      |> IO.inspect()

    _roles =
      [
        %{
          name: "User",
          permissions: 0
        },
        %{
          name: "Boss",
          permissions:
            1 <<< 1 |||
              1 <<< 3 |||
              1 <<< 4 |||
              1 <<< 6
        },
        %{
          name: "Admin",
          permissions: -1
        }
      ]
      |> Enum.map(&Heimdall.Account.create_role/1)
      |> IO.inspect()
  end
end
