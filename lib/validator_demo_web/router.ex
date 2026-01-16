defmodule ValidatorDemoWeb.Router do
  use ValidatorDemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ValidatorDemoWeb do
    pipe_through :api

    post "/users", UserController, :create
    get "/users/:id", UserController, :show
    get "/users", UserController, :index
  end
end
