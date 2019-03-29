defmodule HeimdallWeb.DoorController do
  use HeimdallWeb, :controller

  import Ecto.Query, warn: false

  alias Heimdall.Account
  alias Heimdall.Equipment
  alias Heimdall.Equipment.Door

  def index(conn, params) do
    %Paginator.Page{entries: doors, metadata: metadata} =
      from(Door, order_by: [asc: :name])
      |> Heimdall.Repo.paginate(
        sort_direction: :asc,
        cursor_fields: [:name],
        maximum_limit: 50,
        limit: Map.get(params, "limit", 10),
        after: Map.get(params, "after"),
        before: Map.get(params, "before")
      )

    can_modify =
      Guardian.Plug.current_resource(conn)
      |> Account.has_permission("door:modify")

    render(conn, "index.html", doors: doors, metadata: metadata, can_modify: can_modify)
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
    door =
      Equipment.get_door!(id)
      |> Heimdall.Repo.preload([:door_users, :users])

    door_owners =
      door
      |> Map.get(:door_users)
      |> Enum.map(fn door_user ->
        {door_user.user.code, door_user.owner}
      end)
      |> Map.new()

    render(conn, "show.html", door: door, door_owners: door_owners)
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
