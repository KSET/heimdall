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

  def logs(conn, params) do
    %Paginator.Page{entries: logs, metadata: metadata} =
      from(
        log in Heimdall.Log,
        select: log,
        order_by: [desc: :id]
      )
      |> Heimdall.Repo.paginate(
        cursor_fields: [:id],
        sort_direction: :desc,
        maximum_limit: 50,
        limit: Map.get(params, "limit", 10),
        after: Map.get(params, "after"),
        before: Map.get(params, "before")
      )

    conn
    |> render("logs.json", %{logs: logs, metadata: metadata})
  end

  def logs_for_user(conn, %{"user_id" => id} = params) do
    %Paginator.Page{entries: logs, metadata: metadata} =
      from(
        log in Heimdall.Log,
        order_by: [desc: :id],
        where: log.user_id == ^id
      )
      |> Heimdall.Repo.paginate(
        cursor_fields: [:id],
        maximum_limit: 50,
        limit: Map.get(params, "limit", 10),
        after: Map.get(params, "after"),
        before: Map.get(params, "before")
      )

    conn
    |> render("logs.json", %{logs: logs, metadata: metadata})
  end
end
