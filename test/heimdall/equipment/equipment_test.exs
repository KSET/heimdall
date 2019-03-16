defmodule Heimdall.EquipmentTest do
  use Heimdall.DataCase

  alias Heimdall.Equipment

  describe "doors" do
    alias Heimdall.Equipment.Door

    @valid_attrs %{code: "some code", name: "some name"}
    @update_attrs %{code: "some updated code", name: "some updated name"}
    @invalid_attrs %{code: nil, name: nil}

    def door_fixture(attrs \\ %{}) do
      {:ok, door} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Equipment.create_door()

      door
    end

    test "list_doors/0 returns all doors" do
      door = door_fixture()
      assert Equipment.list_doors() == [door]
    end

    test "get_door!/1 returns the door with given id" do
      door = door_fixture()
      assert Equipment.get_door!(door.id) == door
    end

    test "create_door/1 with valid data creates a door" do
      assert {:ok, %Door{} = door} = Equipment.create_door(@valid_attrs)
      assert door.code == "some code"
      assert door.name == "some name"
    end

    test "create_door/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Equipment.create_door(@invalid_attrs)
    end

    test "update_door/2 with valid data updates the door" do
      door = door_fixture()
      assert {:ok, door} = Equipment.update_door(door, @update_attrs)
      assert %Door{} = door
      assert door.code == "some updated code"
      assert door.name == "some updated name"
    end

    test "update_door/2 with invalid data returns error changeset" do
      door = door_fixture()
      assert {:error, %Ecto.Changeset{}} = Equipment.update_door(door, @invalid_attrs)
      assert door == Equipment.get_door!(door.id)
    end

    test "delete_door/1 deletes the door" do
      door = door_fixture()
      assert {:ok, %Door{}} = Equipment.delete_door(door)
      assert_raise Ecto.NoResultsError, fn -> Equipment.get_door!(door.id) end
    end

    test "change_door/1 returns a door changeset" do
      door = door_fixture()
      assert %Ecto.Changeset{} = Equipment.change_door(door)
    end
  end
end
