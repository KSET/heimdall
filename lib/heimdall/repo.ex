defmodule Heimdall.Repo do
  use Ecto.Repo, otp_app: :heimdall, adapter: Ecto.Adapters.Postgres
  use Paginator

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
