defmodule HeimdallWeb.ApiController do
  use HeimdallWeb, :controller

  import Ecto.Query, warn: false

  alias Heimdall.Relations

  @spec request_access(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def request_access(conn, %{"user" => user, "door" => door}) do
    data = %{
      user: user,
      door: door,
      success: Relations.process_user_door_access(user, door)
    }

    data
    |> Heimdall.Log.add_attempt()

    conn
    |> render("request-access.json", data)
  end
end
