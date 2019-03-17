defmodule Heimdall.Account.Encryption do
  alias Argon2, as: Hasher

  @spec hash_password(String.t()) :: binary()
  def hash_password(password), do: Hasher.hash_pwd_salt(password)

  @spec validate_password(String.t(), String.t()) :: boolean()
  def validate_password(password, hash), do: Hasher.verify_pass(password, hash)
end
