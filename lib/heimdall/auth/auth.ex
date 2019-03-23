defmodule Heimdall.Auth do
  @moduledoc """
  The boundry for the Auth system
  """

  import Ecto.{Query, Changeset}, warn: false

  alias Heimdall.Repo
  alias Heimdall.Account.{User, Encryption}

  @spec check_credentials(binary(), binary()) :: {:error, String.t()} | {:ok, %User{}}
  def check_credentials(code, password) do
    user = Repo.get_by(User, code: String.downcase(code))

    user
    |> check_password(password)
    |> if do
      {:ok, user}
    else
      {:error, "Could not login"}
    end
  end

  defp check_password(nil, _password), do: false
  defp check_password(user, password), do: Encryption.validate_password(password, user.password)
end
