defmodule HeimdallWeb.Guardian do
  @moduledoc """
  This module is required by Guardian, to implements all type or configuration for
  the auth token.
  Also, is used to retrieve and deliver the authentication subject to Guardian.
  More details here: https://github.com/ueberauth/guardian#installation
  """

  use Guardian, otp_app: :real_world

  alias Heimdall.{Account, Account.User}

  def subject_for_token(%User{} = user, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => user_id}), do: {:ok, Account.get_user!(user_id)}
  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}
end
