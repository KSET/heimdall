defmodule HeimdallWeb.DoorController do
  use HeimdallWeb, :controller

  alias Heimdall.Equipment
  alias Heimdall.Equipment.Door

  def index(conn, _params) do
    doors = Equipment.list_doors()
    render(conn, "index.html", doors: doors)
  end

  def new(conn, _params) do
    changeset = Equipment.change_door(%Door{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"door" => door_params}) do
    case Equipment.create_door(door_params) do
      {:ok, door} ->
        conn
        |> put_flash(:info, "Door created successfully.")
        |> redirect(to: door_path(conn, :show, door))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    door = Equipment.get_door!(id)
    render(conn, "show.html", door: door)
  end

  def edit(conn, %{"id" => id}) do
    door = Equipment.get_door!(id)
    changeset = Equipment.change_door(door)
    render(conn, "edit.html", door: door, changeset: changeset)
  end

  def update(conn, %{"id" => id, "door" => door_params}) do
    door = Equipment.get_door!(id)

    case Equipment.update_door(door, door_params) do
      {:ok, door} ->
        conn
        |> put_flash(:info, "Door updated successfully.")
        |> redirect(to: door_path(conn, :show, door))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", door: door, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    door = Equipment.get_door!(id)
    {:ok, _door} = Equipment.delete_door(door)

    conn
    |> put_flash(:info, "Door deleted successfully.")
    |> redirect(to: door_path(conn, :index))
  end
end
