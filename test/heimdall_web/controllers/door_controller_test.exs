defmodule HeimdallWeb.DoorControllerTest do
  use HeimdallWeb.ConnCase

  alias Heimdall.Equipment

  @create_attrs %{code: "some code", name: "some name"}
  @update_attrs %{code: "some updated code", name: "some updated name"}
  @invalid_attrs %{code: nil, name: nil}

  def fixture(:door) do
    {:ok, door} = Equipment.create_door(@create_attrs)
    door
  end

  describe "index" do
    test "lists all doors", %{conn: conn} do
      conn = get conn, door_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Doors"
    end
  end

  describe "new door" do
    test "renders form", %{conn: conn} do
      conn = get conn, door_path(conn, :new)
      assert html_response(conn, 200) =~ "New Door"
    end
  end

  describe "create door" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, door_path(conn, :create), door: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == door_path(conn, :show, id)

      conn = get conn, door_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Door"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, door_path(conn, :create), door: @invalid_attrs
      assert html_response(conn, 200) =~ "New Door"
    end
  end

  describe "edit door" do
    setup [:create_door]

    test "renders form for editing chosen door", %{conn: conn, door: door} do
      conn = get conn, door_path(conn, :edit, door)
      assert html_response(conn, 200) =~ "Edit Door"
    end
  end

  describe "update door" do
    setup [:create_door]

    test "redirects when data is valid", %{conn: conn, door: door} do
      conn = put conn, door_path(conn, :update, door), door: @update_attrs
      assert redirected_to(conn) == door_path(conn, :show, door)

      conn = get conn, door_path(conn, :show, door)
      assert html_response(conn, 200) =~ "some updated code"
    end

    test "renders errors when data is invalid", %{conn: conn, door: door} do
      conn = put conn, door_path(conn, :update, door), door: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Door"
    end
  end

  describe "delete door" do
    setup [:create_door]

    test "deletes chosen door", %{conn: conn, door: door} do
      conn = delete conn, door_path(conn, :delete, door)
      assert redirected_to(conn) == door_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, door_path(conn, :show, door)
      end
    end
  end

  defp create_door(_) do
    door = fixture(:door)
    {:ok, door: door}
  end
end
