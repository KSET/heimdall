defmodule HeimdallWeb.Router do
  use HeimdallWeb, :router

  pipeline :auth do
    plug(Heimdall.Auth.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", HeimdallWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    post("/", PageController, :login)
    post("/logout", PageController, :logout)
  end

  scope "/", HeimdallWeb do
    pipe_through([:browser, :auth, :ensure_auth])

    resources("/users", UserController)
    resources("/doors", DoorController)

    get("/logs", LogController, :index)
    get("/logs/:user_id", LogController, :for_user)
  end

  scope "/api", HeimdallWeb do
    pipe_through([:api, :auth])

    post("/equipment/doors/request-access", ApiController, :request_access)
    get("/logs", ApiController, :logs)
    get("/logs/:user_id", ApiController, :logs_for_user)
  end

  # Other scopes may use custom stacks.
  # scope "/api", HeimdallWeb do
  #   pipe_through :api
  # end
end
