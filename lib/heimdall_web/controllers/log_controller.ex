defmodule HeimdallWeb.LogController do
  use HeimdallWeb, :controller

  import Ecto.Query, warn: false

  alias Heimdall.Log

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    %Paginator.Page{entries: logs, metadata: metadata} =
      from(
        log in Log.owned_query(user),
        order_by: [desc: log.id]
      )
      |> Heimdall.Repo.paginate(
        cursor_fields: [:id],
        sort_direction: :desc,
        maximum_limit: 50,
        limit: Map.get(params, "limit", 10),
        after: Map.get(params, "after"),
        before: Map.get(params, "before")
      )

    render(conn, "index.html",
      logs: logs |> Heimdall.Repo.preload([:door, :user]),
      metadata: metadata
    )
  end

  def for_user(conn, %{"user_code" => code} = params) do
    %Paginator.Page{entries: logs, metadata: metadata} =
      from(
        log in Heimdall.Log,
        order_by: [desc: :id],
        where: log.user_code == ^code
      )
      |> Heimdall.Repo.paginate(
        cursor_fields: [:id],
        maximum_limit: 50,
        limit: Map.get(params, "limit", 10),
        after: Map.get(params, "after"),
        before: Map.get(params, "before")
      )

    render(conn, "index.html",
      logs: logs |> Heimdall.Repo.preload([:door, :user]),
      metadata: metadata
    )
  end
end
