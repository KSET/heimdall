defmodule HeimdallWeb.ApiView do
  use HeimdallWeb, :view

  def render("request-access.json", params) do
    params
    |> Map.take([:user, :door, :success])
  end
end
