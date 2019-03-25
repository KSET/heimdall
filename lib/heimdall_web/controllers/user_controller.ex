defmodule HeimdallWeb.UserController do
  use HeimdallWeb, :controller

  import Ecto.Query, warn: false

  alias Heimdall.Repo
  alias Heimdall.Account
  alias Heimdall.Account.User

  def index(conn, params) do
    %Paginator.Page{entries: users, metadata: metadata} =
      from(User, order_by: [desc: :id])
      |> Heimdall.Repo.paginate(
        sort_direction: :desc,
        cursor_fields: [:id],
        maximum_limit: 50,
        limit: Map.get(params, "limit", 10),
        after: Map.get(params, "after"),
        before: Map.get(params, "before")
      )

    can_modify =
      Guardian.Plug.current_resource(conn)
      |> Account.has_permission("user:modify")

    render(conn, "index.html", users: users, metadata: metadata, can_modify: can_modify)
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user =
      Account.get_user!(id)
      |> Repo.preload([:created, :created_by, :doors, :role])

    can_modify =
      Guardian.Plug.current_resource(conn)
      |> Account.has_permission("user:modify")

    render(conn, "show.html", user: user, can_modify: can_modify)
  end

  def edit(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    case Account.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    {:ok, _user} = Account.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
