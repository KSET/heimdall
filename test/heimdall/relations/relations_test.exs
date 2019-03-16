defmodule Heimdall.RelationsTest do
  use Heimdall.DataCase

  alias Heimdall.Relations

  describe "door_users" do
    alias Heimdall.Relations.DoorUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def door_user_fixture(attrs \\ %{}) do
      {:ok, door_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Relations.create_door_user()

      door_user
    end

    test "list_door_users/0 returns all door_users" do
      door_user = door_user_fixture()
      assert Relations.list_door_users() == [door_user]
    end

    test "get_door_user!/1 returns the door_user with given id" do
      door_user = door_user_fixture()
      assert Relations.get_door_user!(door_user.id) == door_user
    end

    test "create_door_user/1 with valid data creates a door_user" do
      assert {:ok, %DoorUser{} = door_user} = Relations.create_door_user(@valid_attrs)
    end

    test "create_door_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Relations.create_door_user(@invalid_attrs)
    end

    test "update_door_user/2 with valid data updates the door_user" do
      door_user = door_user_fixture()
      assert {:ok, door_user} = Relations.update_door_user(door_user, @update_attrs)
      assert %DoorUser{} = door_user
    end

    test "update_door_user/2 with invalid data returns error changeset" do
      door_user = door_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Relations.update_door_user(door_user, @invalid_attrs)
      assert door_user == Relations.get_door_user!(door_user.id)
    end

    test "delete_door_user/1 deletes the door_user" do
      door_user = door_user_fixture()
      assert {:ok, %DoorUser{}} = Relations.delete_door_user(door_user)
      assert_raise Ecto.NoResultsError, fn -> Relations.get_door_user!(door_user.id) end
    end

    test "change_door_user/1 returns a door_user changeset" do
      door_user = door_user_fixture()
      assert %Ecto.Changeset{} = Relations.change_door_user(door_user)
    end
  end
end
