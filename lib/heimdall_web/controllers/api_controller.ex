defmodule HeimdallWeb.ApiController do
  use HeimdallWeb, :controller

  import Ecto.Query, warn: false

  alias Heimdall.Relations

  @spec request_access(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def request_access(conn, %{"user" => user, "door" => door}) do
    data =
      try do
        {user, door} = {to_string(user), to_string(door)}

        %{
          user: user,
          door: door,
          success: Relations.process_user_door_access(user, door)
        }
      rescue
        Protocol.UndefinedError ->
          %{
            user: "",
            door: "",
            success: false
          }
      end

    data
    |> Heimdall.Log.add_attempt(Heimdall.Log.Types.AccessRequest)

    conn
    |> render("request-access.json", data)
  end

  def request_access(conn, params) do
    conn
    |> missing_params([:door, :user], Map.keys(params))
  end

  @spec door_event(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def door_event(conn, %{"door" => door, "opened" => open}) do
    data = %{
      door: to_string(door),
      success: open,
      user: ""
    }

    data
    |> Heimdall.Log.add_attempt(Heimdall.Log.Types.DoorEvent)

    conn
    |> render("door-event.json", data)
  end

  def door_event(conn, params) do
    conn
    |> missing_params([:door, :opened], Map.keys(params))
  end

  @spec request_access(Plug.Conn.t(), map()) :: Plug.Conn.t()
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

  def logs_for_user(conn, %{"user_code" => code} = params) do
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

    conn
    |> render("logs.json", %{logs: logs, metadata: metadata})
  end

  defp missing_params(conn, required_params, params) do
    required =
      required_params
      |> Enum.map(&to_string(&1))

    missing = required -- params

    missing_string =
      missing
      |> Enum.join("', '")

    conn
    |> put_status(400)
    |> json(%{
      error: true,
      message: "Missing parameters. Required parameters are: '#{missing_string}'",
      required_params: required,
      provided_params: params,
      missing_params: missing
    })
  end
end
