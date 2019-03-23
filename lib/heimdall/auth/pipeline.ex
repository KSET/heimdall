defmodule Heimdall.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :heimdall,
    error_handler: Heimdall.Auth.ErrorHandler,
    module: Heimdall.Auth.Guardian

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
