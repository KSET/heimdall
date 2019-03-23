defmodule HeimdallWeb.PageController do
  use HeimdallWeb, :controller

  alias Heimdall.{Account, Account.User}
  alias Heimdall.{Auth, Auth.Guardian}

  def index(conn, _params) do
    changeset = Account.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    conn
    |> render(
      "index.html",
      changeset: changeset,
      action: page_path(conn, :login),
      maybe_user: maybe_user
    )
  end

  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login(conn, %{"user" => %{"code" => code, "password" => password}}) do
    Auth.check_credentials(code, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: page_path(conn, :login))
  end
end
