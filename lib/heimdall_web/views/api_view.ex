defmodule HeimdallWeb.ApiView do
  use HeimdallWeb, :view

  def render("request-access.json", params) do
    params
    |> Map.take([:user, :door, :success])
  end

  def render("logs.json", %{logs: logs}) do
    logs
    |> Enum.map(&Heimdall.Log.to_map/1)
  end
end
